import Foundation

public struct Deck: Codable, Hashable, Sendable {
    public let id: DeckID
    public var title: String
    public var createdAt: Date
    public var updatedAt: Date

    public init(
        id: DeckID = DeckID(),
        title: String,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public struct Flashcard: Codable, Hashable, Sendable {
    public let id: FlashcardID
    public let deckID: DeckID
    public var frontText: String
    public var backText: String
    public var noteID: NoteID?
    public var imageAssetIDs: [ImageAssetID]

    public init(
        id: FlashcardID = FlashcardID(),
        deckID: DeckID,
        frontText: String,
        backText: String,
        noteID: NoteID? = nil,
        imageAssetIDs: [ImageAssetID] = []
    ) {
        self.id = id
        self.deckID = deckID
        self.frontText = frontText
        self.backText = backText
        self.noteID = noteID
        self.imageAssetIDs = imageAssetIDs
    }
}

public struct CardNote: Codable, Hashable, Sendable {
    public let id: NoteID
    public let deckID: DeckID
    public let flashcardID: FlashcardID
    public var plainTextContent: String

    public init(
        id: NoteID = NoteID(),
        deckID: DeckID,
        flashcardID: FlashcardID,
        plainTextContent: String = ""
    ) {
        self.id = id
        self.deckID = deckID
        self.flashcardID = flashcardID
        self.plainTextContent = plainTextContent
    }
}

public struct ImageAsset: Codable, Hashable, Sendable {
    public let id: ImageAssetID
    public let deckID: DeckID
    public let flashcardID: FlashcardID
    public var canonicalFilename: String
    public var originalFilename: String?

    public init(
        id: ImageAssetID = ImageAssetID(),
        deckID: DeckID,
        flashcardID: FlashcardID,
        canonicalFilename: String,
        originalFilename: String? = nil
    ) {
        self.id = id
        self.deckID = deckID
        self.flashcardID = flashcardID
        self.canonicalFilename = canonicalFilename
        self.originalFilename = originalFilename
    }
}
