import XCTest
import GradeFlipBilling
@testable import GradeFlipDomain
@testable import GradeFlipOnline
@testable import GradeFlipStorage

final class OnlineModelsTests: XCTestCase {
    func testRecommendedBackendUsesSupabaseAndRLS() {
        XCTAssertEqual(OnlineBackendSelection.recommendedSupabase.kind, .supabasePostgres)
        XCTAssertTrue(OnlineBackendSelection.recommendedSupabase.usesRowLevelSecurity)
    }

    func testSyncPlannerUploadsDownloadsAndConflicts() {
        let owner = UserID()
        let localDeckOnly = makeLocalSnapshot(title: "Local only", updatedAt: Date(timeIntervalSince1970: 100))
        let localAheadDeck = makeLocalSnapshot(title: "Local ahead", updatedAt: Date(timeIntervalSince1970: 200))
        let conflictDeck = makeLocalSnapshot(title: "Conflict", updatedAt: Date(timeIntervalSince1970: 300))
        let remoteOnly = CloudDeckRecord(
            deck: Deck(title: "Remote only", updatedAt: Date(timeIntervalSince1970: 150)),
            cards: [],
            notes: [],
            imageAssets: [],
            ownerUserID: owner,
            updatedAt: Date(timeIntervalSince1970: 150)
        )
        let localAheadRemoteDeck = Deck(
            id: DeckID(rawValue: localAheadDeck.deckID)!,
            title: localAheadDeck.title,
            updatedAt: Date(timeIntervalSince1970: 120)
        )
        let remoteAhead = CloudDeckRecord(
            deck: localAheadRemoteDeck,
            cards: [],
            notes: [],
            imageAssets: [],
            ownerUserID: owner,
            updatedAt: Date(timeIntervalSince1970: 120)
        )
        let conflictRemoteDeck = Deck(
            id: DeckID(rawValue: conflictDeck.deckID)!,
            title: conflictDeck.title,
            updatedAt: Date(timeIntervalSince1970: 303)
        )
        let conflictingRemote = CloudDeckRecord(
            deck: conflictRemoteDeck,
            cards: [],
            notes: [],
            imageAssets: [],
            ownerUserID: owner,
            updatedAt: Date(timeIntervalSince1970: 303)
        )

        let plan = DeckSyncPlanner().plan(
            localDecks: [localDeckOnly, localAheadDeck, conflictDeck],
            remoteDecks: [remoteOnly, remoteAhead, conflictingRemote]
        )

        XCTAssertEqual(plan.decksToUpload, [localAheadDeck.deckID, localDeckOnly.deckID].sorted())
        XCTAssertEqual(plan.decksToDownload, [remoteOnly.deck.id.rawValue])
        XCTAssertEqual(plan.conflicts.map { $0.deckID }, [conflictDeck.deckID])
        XCTAssertEqual(plan.conflicts.first?.suggestedResolution, .mergePreservingIdentifiers)
    }

    func testSocialGraphRecordsBuddyAndShareEvents() {
        let firstUser = UserID()
        let secondUser = UserID()
        let deckID = DeckID()
        var graph = SocialGraph()

        let request = graph.sendBuddyRequest(from: firstUser, to: secondUser)
        graph.respondToBuddyRequest(request.id, accept: true)
        graph.shareDeck(deckID: deckID, from: firstUser, to: secondUser, canCopyToLibrary: true)
        graph.requestDeck(deckID: deckID, from: secondUser, to: firstUser)
        graph.likeDeck(deckID: deckID, from: secondUser, to: firstUser)

        XCTAssertEqual(graph.relationships.count, 1)
        XCTAssertEqual(graph.sharedDecks.count, 1)
        XCTAssertEqual(graph.likes.count, 1)
        XCTAssertEqual(graph.events.map(\.kind), [.buddyRequest, .buddyAccepted, .deckShare, .deckRequest, .deckLike])
    }

    func testSubscriptionEntitlementOnlyUnlocksActiveOrGracePeriod() {
        let userID = UserID()
        let baseSnapshot = EntitlementSnapshot(
            hasPaidCoreAccess: true,
            hasOnlineSubscription: false,
            availableStudyTokens: 0,
            accountState: .signedIn
        )

        let active = SubscriptionEntitlement(
            userID: userID,
            status: .active,
            renewalDate: .now,
            productID: "gradeflip.online.monthly"
        )
        let expired = SubscriptionEntitlement(
            userID: userID,
            status: .expired,
            renewalDate: nil,
            productID: "gradeflip.online.monthly"
        )

        XCTAssertTrue(active.appliesOnlinePremiumCapabilities(to: baseSnapshot).hasOnlineSubscription)
        XCTAssertFalse(expired.appliesOnlinePremiumCapabilities(to: baseSnapshot).hasOnlineSubscription)
    }

    func testStudyStreakEngineBuildsConsecutiveDailyStreak() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let engine = StudyStreakEngine(calendar: calendar)
        let userID = UserID()
        let buddyID = UserID()
        let deckID = DeckID()

        let events = [
            StudyActivityEvent(userID: userID, buddyUserID: buddyID, occurredOn: Date(timeIntervalSince1970: 0), deckID: deckID),
            StudyActivityEvent(userID: userID, buddyUserID: buddyID, occurredOn: Date(timeIntervalSince1970: 86400), deckID: deckID),
            StudyActivityEvent(userID: userID, buddyUserID: buddyID, occurredOn: Date(timeIntervalSince1970: 172800), deckID: deckID),
        ]

        let streaks = engine.buildStreaks(from: events)

        XCTAssertEqual(streaks.count, 1)
        XCTAssertEqual(streaks.first?.qualifyingDays, 3)
        XCTAssertEqual(streaks.first?.buddyUserID, buddyID)
    }

    private func makeLocalSnapshot(title: String, updatedAt: Date) -> LocalDeckIndexSnapshot {
        let deck = Deck(title: title, updatedAt: updatedAt)
        return LocalDeckIndexSnapshot(
            deckID: deck.id.rawValue,
            title: title,
            cardCount: 0,
            noteCount: 0,
            imageCount: 0,
            updatedAt: updatedAt
        )
    }
}
