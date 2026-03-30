import XCTest
@testable import GradeFlipAI
@testable import GradeFlipDomain
@testable import GradeFlipStorage

final class AIContractsTests: XCTestCase {
    func testGroundingBuilderPackagesSelectedDecksOnly() {
        let selectedDeck = makeSnapshot(title: "Selected")
        let otherDeck = makeSnapshot(title: "Other")

        let package = DeckGroundingBuilder().makeGroundingPackage(
            from: [selectedDeck, otherDeck],
            selectedDeckIDs: [selectedDeck.contents.deck.id]
        )

        XCTAssertEqual(package.selectedDeckIDs, [selectedDeck.contents.deck.id])
        XCTAssertEqual(package.sourceCardCount, 1)
        XCTAssertTrue(package.promptContext.contains("Selected"))
        XCTAssertFalse(package.promptContext.contains("Other"))
    }

    func testEstimatorComputesDeterministicCharge() {
        let model = AIProviderCatalog.default.models(for: .openAI).first!
        let request = AIChatRequest(
            mode: .deckGrounded,
            model: model,
            messages: [AIChatMessage(role: .user, content: "Explain osmosis in simple terms.")],
            grounding: nil,
            reservedOutputTokens: 300
        )

        let estimate = StudyTokenEstimator(pricingCatalog: .placeholder).estimate(for: request)

        XCTAssertGreaterThan(estimate.inputTokens, 0)
        XCTAssertEqual(estimate.reservedOutputTokens, 300)
        XCTAssertGreaterThan(estimate.estimatedStudyTokenCharge, 0)
    }

    func testReconciliationProducesAdjustment() {
        let model = AIProviderCatalog.default.models(for: .openAI).first!
        let estimator = StudyTokenEstimator(pricingCatalog: .placeholder)
        let request = AIChatRequest(
            mode: .webEnabled,
            model: model,
            messages: [AIChatMessage(role: .user, content: "Search and summarize the latest findings.")],
            grounding: nil,
            reservedOutputTokens: 500
        )
        let estimate = estimator.estimate(for: request)

        let reconciliation = estimator.reconcile(
            estimate: estimate,
            modelID: model.modelID,
            mode: .webEnabled,
            actualInputTokens: estimate.inputTokens,
            actualOutputTokens: 200
        )

        XCTAssertEqual(reconciliation.adjustment, reconciliation.finalStudyTokenCharge - estimate.estimatedStudyTokenCharge)
    }

    func testLedgerIgnoresDuplicateReferenceForSameKind() {
        var ledger = StudyTokenLedger()
        let entry = StudyTokenLedgerEntry(kind: .purchase, amount: 100, reference: "purchase-1")

        ledger.record(entry)
        ledger.record(entry)

        XCTAssertEqual(ledger.entries.count, 1)
        XCTAssertEqual(ledger.balance, 100)
    }

    func testWalletGiftCreatesDebitAndRecipientCreditEntries() {
        let senderID = UserID()
        let recipientID = UserID()
        var wallet = StudyTokenWallet(ownerUserID: senderID)
        wallet.record(StudyTokenLedgerEntry(kind: .purchase, amount: 50, reference: "seed"))

        let transfer = wallet.gift(amount: 20, to: recipientID, reference: "gift-1")

        XCTAssertEqual(wallet.balance, 30)
        XCTAssertEqual(transfer.senderEntry.amount, -20)
        XCTAssertEqual(transfer.recipientEntry.amount, 20)
        XCTAssertEqual(transfer.recipientEntry.kind, .giftReceived)
    }

    private func makeSnapshot(title: String) -> LocalDeckSnapshot {
        let deck = Deck(title: title)
        let card = Flashcard(deckID: deck.id, frontText: "Front", backText: "Back")
        return LocalDeckSnapshot(
            contents: StoredDeckContents(deck: deck, cards: [card], imageAssets: [], savedAt: .now),
            notes: StoredDeckNotes(
                deckID: deck.id,
                notes: [CardNote(deckID: deck.id, flashcardID: card.id, plainTextContent: "Helpful note")],
                savedAt: .now
            )
        )
    }
}
