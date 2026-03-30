import XCTest
@testable import GradeFlipDomain
@testable import GradeFlipStorage

final class LocalDeckImagesTests: XCTestCase {
    private var rootURL: URL!
    private var store: LocalDeckFileStore!
    private var library: LocalDeckLibrary!

    override func setUpWithError() throws {
        let tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("GradeFlipImagesTests", isDirectory: true)
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

    func testAttachImageStoresMetadataAndFile() throws {
        let deck = try library.createDeck(title: "Biology")
        let withCard = try library.createFlashcard(in: deck.contents.deck.id, frontText: "Cell", backText: "Life")
        let cardID = try XCTUnwrap(withCard.contents.cards.first?.id)

        let updated = try library.attachImage(
            deckID: deck.contents.deck.id,
            flashcardID: cardID,
            data: Data([0x01, 0x02]),
            originalFilename: "diagram.png"
        )

        XCTAssertEqual(updated.contents.imageAssets.count, 1)
        XCTAssertEqual(updated.contents.cards.first?.imageAssetIDs.count, 1)
    }

    func testRemoveImageDeletesMetadataAndFile() throws {
        let deck = try library.createDeck(title: "Chemistry")
        let withCard = try library.createFlashcard(in: deck.contents.deck.id, frontText: "Atom", backText: "Matter")
        let cardID = try XCTUnwrap(withCard.contents.cards.first?.id)
        let withImage = try library.attachImage(
            deckID: deck.contents.deck.id,
            flashcardID: cardID,
            data: Data([0x0A]),
            originalFilename: "atom.jpg"
        )
        let image = try XCTUnwrap(withImage.contents.imageAssets.first)

        let updated = try library.removeImage(
            deckID: deck.contents.deck.id,
            flashcardID: cardID,
            imageAssetID: image.id
        )

        XCTAssertTrue(updated.contents.imageAssets.isEmpty)
        XCTAssertTrue(updated.contents.cards.first?.imageAssetIDs.isEmpty == true)
    }

    func testDeletingCardRemovesAttachedImageFilesAndMetadata() throws {
        let deck = try library.createDeck(title: "Physics")
        let withCard = try library.createFlashcard(in: deck.contents.deck.id, frontText: "Force", backText: "Mass x acceleration")
        let cardID = try XCTUnwrap(withCard.contents.cards.first?.id)
        let withImage = try library.attachImage(
            deckID: deck.contents.deck.id,
            flashcardID: cardID,
            data: Data([0x0F, 0x0E]),
            originalFilename: "force.png"
        )
        let image = try XCTUnwrap(withImage.contents.imageAssets.first)
        let imageURL = LocalDeckLayout.imagesDirectoryURL(for: deck.contents.deck.id, root: rootURL)
            .appendingPathComponent(image.canonicalFilename)

        XCTAssertTrue(FileManager.default.fileExists(atPath: imageURL.path))

        let updated = try library.deleteFlashcard(deckID: deck.contents.deck.id, flashcardID: cardID)

        XCTAssertTrue(updated.contents.imageAssets.isEmpty)
        XCTAssertFalse(FileManager.default.fileExists(atPath: imageURL.path))
    }
}
