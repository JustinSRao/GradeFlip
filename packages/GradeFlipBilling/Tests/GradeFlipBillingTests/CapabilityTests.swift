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
            availableStudyTokens: 5
        )
        let subscribed = EntitlementSnapshot(
            hasPaidCoreAccess: true,
            hasOnlineSubscription: true,
            availableStudyTokens: 5
        )

        XCTAssertFalse(paidOnly.hasCapability(.onlineSync))
        XCTAssertTrue(subscribed.hasCapability(.onlineSync))
        XCTAssertTrue(subscribed.hasCapability(.studyBuddies))
    }
}
