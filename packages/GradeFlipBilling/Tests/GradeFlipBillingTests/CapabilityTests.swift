import Testing
@testable import GradeFlipBilling

@Test("Offline decks require paid core access")
func offlineCapabilityRequiresPaidCoreAccess() {
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

    #expect(noAccess.hasCapability(.offlineDecks) == false)
    #expect(paidAccess.hasCapability(.offlineDecks) == true)
}

@Test("Online social features require subscription")
func socialCapabilitiesRequireSubscription() {
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

    #expect(paidOnly.hasCapability(.onlineSync) == false)
    #expect(subscribed.hasCapability(.onlineSync) == true)
    #expect(subscribed.hasCapability(.studyBuddies) == true)
}
