import Foundation
import XCTest
@testable import GradeFlipDomain
@testable import GradeFlipStorage

final class LocalDeckFileStoreTests: XCTestCase {
    private var rootURL: URL!
    private var store: LocalDeckFileStore!

    override func setUpWithError() throws {
        let tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("GradeFlipStorageTests", isDirectory: true)
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        rootURL = tempDirectory
        store = LocalDeckFileStore(configuration: LocalDeckStorageConfiguration(rootURL: tempDirectory))
    }

    override func tearDownWithError() throws {
        if let rootURL, FileManager.default.fileExists(atPath: rootURL.path) {
            try FileManager.default.removeItem(at: rootURL)
        }
    }

    func testSaveAndLoadRoundTripsDeckSnapshot() throws {
        let deck = Deck(title: "Biology")
        let card = Flashcard(deckID: deck.id, frontText: "Cell", backText: "Basic unit of life")
        let note = CardNote(deckID: deck.id, flashcardID: card.id, plainTextContent: "Remember mitochondria")

        let snapshot = LocalDeckSnapshot(
            contents: StoredDeckContents(deck: deck, cards: [card]),
            notes: StoredDeckNotes(deckID: deck.id, notes: [note])
        )

        try store.save(snapshot: snapshot)
        let loaded = try store.load(deckID: deck.id)

        XCTAssertEqual(loaded.contents.deck.id, snapshot.contents.deck.id)
        XCTAssertEqual(loaded.contents.deck.title, snapshot.contents.deck.title)
        XCTAssertEqual(loaded.contents.cards.count, snapshot.contents.cards.count)
        XCTAssertEqual(loaded.contents.cards.first?.id, snapshot.contents.cards.first?.id)
        XCTAssertEqual(loaded.contents.cards.first?.deckID, snapshot.contents.cards.first?.deckID)
        XCTAssertEqual(loaded.contents.cards.first?.frontText, snapshot.contents.cards.first?.frontText)
        XCTAssertEqual(loaded.contents.cards.first?.backText, snapshot.contents.cards.first?.backText)
        XCTAssertEqual(loaded.contents.imageAssets, snapshot.contents.imageAssets)
        XCTAssertEqual(loaded.notes.deckID, snapshot.notes.deckID)
        XCTAssertEqual(loaded.notes.notes, snapshot.notes.notes)
        XCTAssertEqual(loaded.contents.schemaVersion, LocalDeckSchemaVersion.current)
        XCTAssertEqual(loaded.notes.schemaVersion, LocalDeckSchemaVersion.current)
    }

    func testAtomicSaveReplacesExistingFiles() throws {
        let deck = Deck(title: "History")
        let initial = LocalDeckSnapshot(
            contents: StoredDeckContents(
                deck: deck,
                cards: [Flashcard(deckID: deck.id, frontText: "Q1", backText: "A1")]
            ),
            notes: StoredDeckNotes(deckID: deck.id)
        )
        let updated = LocalDeckSnapshot(
            contents: StoredDeckContents(
                deck: deck,
                cards: [Flashcard(deckID: deck.id, frontText: "Q2", backText: "A2")]
            ),
            notes: StoredDeckNotes(deckID: deck.id)
        )

        try store.save(snapshot: initial)
        try store.save(snapshot: updated)

        let loaded = try store.load(deckID: deck.id)
        XCTAssertEqual(loaded.contents.cards.map(\.frontText), ["Q2"])
    }

    func testCanonicalImageFilenameUsesGeneratedIDAndOriginalExtension() throws {
        let imageID = ImageAssetID()
        let filename = try LocalDeckFileStore.canonicalImageFilename(
            for: imageID,
            originalFilename: "photo.PNG"
        )

        XCTAssertEqual(filename, "\(imageID.rawValue).png")
    }

    func testStoreImagePersistsFileInDeckImagesDirectory() throws {
        let deckID = DeckID()
        let flashcardID = FlashcardID()
        let imageData = Data([0x01, 0x02, 0x03])

        let imageAsset = try store.storeImage(
            imageData,
            for: deckID,
            flashcardID: flashcardID,
            originalFilename: "diagram.jpg"
        )

        let storedImageURL = LocalDeckLayout
            .imagesDirectoryURL(for: deckID, root: rootURL)
            .appendingPathComponent(imageAsset.canonicalFilename, isDirectory: false)

        XCTAssertEqual(try Data(contentsOf: storedImageURL), imageData)
    }

    func testIndexSnapshotCapturesCountsForFutureSwiftDataIndexing() throws {
        let deck = Deck(title: "Chemistry")
        let card = Flashcard(deckID: deck.id, frontText: "Atom", backText: "Matter")
        let note = CardNote(deckID: deck.id, flashcardID: card.id, plainTextContent: "Core concept")
        let image = ImageAsset(deckID: deck.id, flashcardID: card.id, canonicalFilename: "asset.png")
        let snapshot = LocalDeckSnapshot(
            contents: StoredDeckContents(deck: deck, cards: [card], imageAssets: [image]),
            notes: StoredDeckNotes(deckID: deck.id, notes: [note])
        )

        let index = store.makeIndexSnapshot(for: snapshot)

        XCTAssertEqual(index.deckID, deck.id.rawValue)
        XCTAssertEqual(index.cardCount, 1)
        XCTAssertEqual(index.noteCount, 1)
        XCTAssertEqual(index.imageCount, 1)
    }
}
