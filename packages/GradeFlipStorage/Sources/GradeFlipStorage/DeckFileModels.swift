import Foundation
import GradeFlipDomain

public enum LocalDeckSchemaVersion {
    public static let current = 1
}

public struct StoredDeckContents: Codable, Hashable, Sendable {
    public var schemaVersion: Int
    public var deck: Deck
    public var cards: [Flashcard]
    public var imageAssets: [ImageAsset]
    public var savedAt: Date

    public init(
        schemaVersion: Int = LocalDeckSchemaVersion.current,
        deck: Deck,
        cards: [Flashcard],
        imageAssets: [ImageAsset] = [],
        savedAt: Date = .now
    ) {
        self.schemaVersion = schemaVersion
        self.deck = deck
        self.cards = cards
        self.imageAssets = imageAssets
        self.savedAt = savedAt
    }
}

public struct StoredDeckNotes: Codable, Hashable, Sendable {
    public var schemaVersion: Int
    public var deckID: DeckID
    public var notes: [CardNote]
    public var savedAt: Date

    public init(
        schemaVersion: Int = LocalDeckSchemaVersion.current,
        deckID: DeckID,
        notes: [CardNote] = [],
        savedAt: Date = .now
    ) {
        self.schemaVersion = schemaVersion
        self.deckID = deckID
        self.notes = notes
        self.savedAt = savedAt
    }
}

public struct LocalDeckSnapshot: Hashable, Sendable {
    public var contents: StoredDeckContents
    public var notes: StoredDeckNotes

    public init(contents: StoredDeckContents, notes: StoredDeckNotes) {
        self.contents = contents
        self.notes = notes
    }
}
