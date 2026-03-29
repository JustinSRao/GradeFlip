import Foundation
import XCTest
@testable import GradeFlipDomain
@testable import GradeFlipStorage

final class LocalDeckLibraryTests: XCTestCase {
    private var rootURL: URL!
    private var store: LocalDeckFileStore!
    private var library: LocalDeckLibrary!

    override func setUpWithError() throws {
        let tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("GradeFlipLibraryTests", isDirectory: true)
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

    func testCreateRenameAndListDecks() throws {
        let created = try library.createDeck(title: "Physics")
        _ = try library.renameDeck(deckID: created.contents.deck.id, title: "Advanced Physics")

        let decks = try library.listDecks()

        XCTAssertEqual(decks.count, 1)
        XCTAssertEqual(decks.first?.title, "Advanced Physics")
        XCTAssertEqual(decks.first?.cardCount, 0)
    }

    func testCreateEditAndDeleteFlashcards() throws {
        let deck = try library.createDeck(title: "Biology")
        let withCard = try library.createFlashcard(
            in: deck.contents.deck.id,
            frontText: "Cell",
            backText: "Basic unit"
        )
        let cardID = try XCTUnwrap(withCard.contents.cards.first?.id)

        let updated = try library.updateFlashcard(
            deckID: deck.contents.deck.id,
            flashcardID: cardID,
            frontText: "Cell membrane",
            backText: "Boundary"
        )
        XCTAssertEqual(updated.contents.cards.first?.frontText, "Cell membrane")

        let deleted = try library.deleteFlashcard(
            deckID: deck.contents.deck.id,
            flashcardID: cardID
        )
        XCTAssertTrue(deleted.contents.cards.isEmpty)
    }

    func testDeckRenamePreservesCardRelationships() throws {
        let deck = try library.createDeck(title: "History")
        let withCard = try library.createFlashcard(
            in: deck.contents.deck.id,
            frontText: "1776",
            backText: "Declaration"
        )
        let cardDeckID = try XCTUnwrap(withCard.contents.cards.first?.deckID)

        let renamed = try library.renameDeck(deckID: deck.contents.deck.id, title: "World History")

        XCTAssertEqual(cardDeckID, renamed.contents.deck.id)
        XCTAssertEqual(renamed.contents.cards.first?.deckID, renamed.contents.deck.id)
        XCTAssertEqual(renamed.contents.deck.title, "World History")
    }

    func testDeleteDeckRemovesDeckFromDeckList() throws {
        let deck = try library.createDeck(title: "Chemistry")

        try library.deleteDeck(deckID: deck.contents.deck.id)

        XCTAssertTrue(try library.listDecks().isEmpty)
    }
}
