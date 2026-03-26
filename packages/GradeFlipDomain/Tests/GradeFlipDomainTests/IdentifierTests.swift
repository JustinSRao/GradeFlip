import Testing
@testable import GradeFlipDomain

@Test("Generated identifiers are non-empty")
func generatedIdentifiersAreNonEmpty() {
    #expect(!DeckID().rawValue.isEmpty)
    #expect(!FlashcardID().rawValue.isEmpty)
    #expect(!NoteID().rawValue.isEmpty)
    #expect(!ImageAssetID().rawValue.isEmpty)
    #expect(!UserID().rawValue.isEmpty)
}

@Test("Domain models preserve deck relationships")
func flashcardRelationshipsUseStableIDs() {
    let deckID = DeckID()
    let card = Flashcard(deckID: deckID, frontText: "Q", backText: "A")
    let note = CardNote(deckID: deckID, flashcardID: card.id)

    #expect(card.deckID == deckID)
    #expect(note.deckID == deckID)
    #expect(note.flashcardID == card.id)
}
