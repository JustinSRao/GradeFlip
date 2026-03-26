import Foundation
import GradeFlipDomain

public enum LocalDeckLayout {
    public static let decksDirectoryName = "Decks"
    public static let cardsFilename = "cards.json"
    public static let notesFilename = "notes.json"
    public static let imagesDirectoryName = "images"

    public static func deckDirectory(for deckID: DeckID, root: URL) -> URL {
        root
            .appendingPathComponent(decksDirectoryName, isDirectory: true)
            .appendingPathComponent(deckID.rawValue, isDirectory: true)
    }

    public static func cardsFileURL(for deckID: DeckID, root: URL) -> URL {
        deckDirectory(for: deckID, root: root)
            .appendingPathComponent(cardsFilename, isDirectory: false)
    }

    public static func notesFileURL(for deckID: DeckID, root: URL) -> URL {
        deckDirectory(for: deckID, root: root)
            .appendingPathComponent(notesFilename, isDirectory: false)
    }

    public static func imagesDirectoryURL(for deckID: DeckID, root: URL) -> URL {
        deckDirectory(for: deckID, root: root)
            .appendingPathComponent(imagesDirectoryName, isDirectory: true)
    }
}
