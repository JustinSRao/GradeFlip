import XCTest
@testable import GradeFlipDomain
@testable import GradeFlipStorage

final class LocalDeckNotesTests: XCTestCase {
    private var rootURL: URL!
    private var store: LocalDeckFileStore!
    private var library: LocalDeckLibrary!

    override func setUpWithError() throws {
        let tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("GradeFlipNotesTests", isDirectory: true)
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        rootURL = tempDirectory
        store = LocalDeckFileStore(configuration: LocalDeckStorageConfiguration(rootURL: tempDirectory))
        library = LocalDeckLibrary(store: store)
    }

    override func tearDownWithError() throws {
        if let rootURL, FileManager.default.fileExists(atPath: rootURL.path) {
            try FileManager.default.removeItem(at: rootURL)
        }
    }

    func testUpsertNoteCreatesDeckScopedNoteForFlashcard() throws {
        let deck = try library.createDeck(title: "Biology")
        let withCard = try library.createFlashcard(in: deck.contents.deck.id, frontText: "Cell", backText: "Life")
        let cardID = try XCTUnwrap(withCard.contents.cards.first?.id)

        let snapshot = try library.upsertNote(
            deckID: deck.contents.deck.id,
            flashcardID: cardID,
            plainTextContent: "Lined note"
        )

        XCTAssertEqual(snapshot.notes.notes.count, 1)
        XCTAssertEqual(snapshot.notes.notes.first?.flashcardID, cardID)
        XCTAssertEqual(snapshot.contents.cards.first?.noteID, snapshot.notes.notes.first?.id)
    }

    func testUpsertNoteEditsExistingNoteWithoutDuplicating() throws {
        let deck = try library.createDeck(title: "History")
        let withCard = try library.createFlashcard(in: deck.contents.deck.id, frontText: "1776", backText: "Declaration")
        let cardID = try XCTUnwrap(withCard.contents.cards.first?.id)

        _ = try library.upsertNote(
            deckID: deck.contents.deck.id,
            flashcardID: cardID,
            plainTextContent: "Initial note"
        )
        let updated = try library.upsertNote(
            deckID: deck.contents.deck.id,
            flashcardID: cardID,
            plainTextContent: "Updated note"
        )

        XCTAssertEqual(updated.notes.notes.count, 1)
        XCTAssertEqual(updated.notes.notes.first?.plainTextContent, "Updated note")
    }

    func testDeletingCardRemovesAssociatedNote() throws {
        let deck = try library.createDeck(title: "Chemistry")
        let withCard = try library.createFlashcard(in: deck.contents.deck.id, frontText: "Atom", backText: "Matter")
        let cardID = try XCTUnwrap(withCard.contents.cards.first?.id)
        _ = try library.upsertNote(
            deckID: deck.contents.deck.id,
            flashcardID: cardID,
            plainTextContent: "Attached note"
        )

        let afterDelete = try library.deleteFlashcard(deckID: deck.contents.deck.id, flashcardID: cardID)

        XCTAssertTrue(afterDelete.notes.notes.isEmpty)
    }
}
