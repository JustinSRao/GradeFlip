import XCTest
@testable import GradeFlipBilling

final class CapabilityTests: XCTestCase {
    func testOfflineCapabilityRequiresPaidCoreAccess() {
        let noAccess = EntitlementSnapshot(
            hasPaidCoreAccess: false,
            hasOnlineSubscription: false,
            availableStudyTokens: 0
        )
        let paidAccess = EntitlementSnapshot(
            hasPaidCoreAccess: true,
            hasOnlineSubscription: false,
            availableStudyTokens: 0
        )

        XCTAssertFalse(noAccess.hasCapability(.offlineDecks))
        XCTAssertTrue(paidAccess.hasCapability(.offlineDecks))
    }

    func testSocialCapabilitiesRequireSubscription() {
        let paidOnly = EntitlementSnapshot(
            hasPaidCoreAccess: true,
            hasOnlineSubscription: false,
            availableStudyTokens: 5,
            accountState: .signedIn
        )
        let subscribed = EntitlementSnapshot(
            hasPaidCoreAccess: true,
            hasOnlineSubscription: true,
            availableStudyTokens: 5,
            accountState: .signedIn
        )

        XCTAssertFalse(paidOnly.hasCapability(.onlineSync))
        XCTAssertTrue(subscribed.hasCapability(.onlineSync))
        XCTAssertTrue(subscribed.hasCapability(.studyBuddies))
    }

    func testOnlineCapabilitiesRequireSignedInAccountBeforeSubscription() {
        let anonymousPaidUser = EntitlementSnapshot(
            hasPaidCoreAccess: true,
            hasOnlineSubscription: false,
            availableStudyTokens: 0,
            accountState: .anonymous
        )

        XCTAssertEqual(
            anonymousPaidUser.capabilityStatus(for: .onlineSync).lockReason,
            .accountRequired
        )
    }

    func testAppModeReflectsPaidSubscriptionAndAccountState() {
        let locked = EntitlementSnapshot(
            hasPaidCoreAccess: false,
            hasOnlineSubscription: false,
            availableStudyTokens: 0
        )
        let offline = EntitlementSnapshot(
            hasPaidCoreAccess: true,
            hasOnlineSubscription: false,
            availableStudyTokens: 0
        )
        let upsell = EntitlementSnapshot(
            hasPaidCoreAccess: true,
            hasOnlineSubscription: false,
            availableStudyTokens: 0,
            accountState: .signedIn
        )
        let subscriber = EntitlementSnapshot(
            hasPaidCoreAccess: true,
            hasOnlineSubscription: true,
            availableStudyTokens: 3,
            accountState: .signedIn
        )

        XCTAssertEqual(locked.appMode(), .locked)
        XCTAssertEqual(offline.appMode(), .offlineCore)
        XCTAssertEqual(upsell.appMode(), .onlineUpsell)
        XCTAssertEqual(subscriber.appMode(), .onlineSubscriber)
    }

    func testTokenPurchasesAreRecommendedForAIWhenBalanceIsEmpty() {
        let snapshot = EntitlementSnapshot(
            hasPaidCoreAccess: true,
            hasOnlineSubscription: false,
            availableStudyTokens: 0
        )

        let surface = snapshot.purchaseSurface(for: .spendAITokens, catalog: .placeholder)

        XCTAssertEqual(surface?.recommendedProducts.map(\.kind), [.aiTokenPack, .aiTokenPack])
    }

    func testPlaceholderCatalogCarriesCoreSubscriptionAndTokenProducts() {
        let catalog = GradeFlipProductCatalog.placeholder

        XCTAssertEqual(catalog.paidCoreUnlock.kind, .paidCoreUnlock)
        XCTAssertEqual(catalog.onlineSubscriptionMonthly.kind, .onlineSubscription)
        XCTAssertEqual(catalog.aiTokenPacks.count, 2)
    }
}
