import XCTest
@testable import GradeFlipDomain

final class IdentifierTests: XCTestCase {
    func testGeneratedIdentifiersAreNonEmpty() {
        XCTAssertFalse(DeckID().rawValue.isEmpty)
        XCTAssertFalse(FlashcardID().rawValue.isEmpty)
        XCTAssertFalse(NoteID().rawValue.isEmpty)
        XCTAssertFalse(ImageAssetID().rawValue.isEmpty)
        XCTAssertFalse(UserID().rawValue.isEmpty)
    }

    func testFlashcardRelationshipsUseStableIDs() {
        let deckID = DeckID()
        let card = Flashcard(deckID: deckID, frontText: "Q", backText: "A")
        let note = CardNote(deckID: deckID, flashcardID: card.id)

        XCTAssertEqual(card.deckID, deckID)
        XCTAssertEqual(note.deckID, deckID)
        XCTAssertEqual(note.flashcardID, card.id)
    }

    func testIdentifiersAndModelsRoundTripThroughCodable() throws {
        let deck = Deck(title: "Biology")
        let card = Flashcard(deckID: deck.id, frontText: "Q", backText: "A")
        let note = CardNote(deckID: deck.id, flashcardID: card.id, plainTextContent: "note")
        let image = ImageAsset(
            deckID: deck.id,
            flashcardID: card.id,
            canonicalFilename: "image.png",
            originalFilename: "original.png"
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let encodedDeck = try encoder.encode(deck)
        let encodedCard = try encoder.encode(card)
        let encodedNote = try encoder.encode(note)
        let encodedImage = try encoder.encode(image)

        XCTAssertEqual(try decoder.decode(Deck.self, from: encodedDeck), deck)
        XCTAssertEqual(try decoder.decode(Flashcard.self, from: encodedCard), card)
        XCTAssertEqual(try decoder.decode(CardNote.self, from: encodedNote), note)
        XCTAssertEqual(try decoder.decode(ImageAsset.self, from: encodedImage), image)
    }
}
