import Foundation

public enum LocalDeckProtection: String, Codable, Hashable, Sendable {
    case none
    case completeUntilFirstUserAuthentication
}

public struct LocalDeckStorageConfiguration: Hashable, Sendable {
    public var rootURL: URL
    public var protection: LocalDeckProtection
    public var prefersSwiftDataIndex: Bool

    public init(
        rootURL: URL,
        protection: LocalDeckProtection = .completeUntilFirstUserAuthentication,
        prefersSwiftDataIndex: Bool = true
    ) {
        self.rootURL = rootURL
        self.protection = protection
        self.prefersSwiftDataIndex = prefersSwiftDataIndex
    }
}

public struct LocalDeckIndexSnapshot: Codable, Hashable, Sendable {
    public var deckID: String
    public var title: String
    public var cardCount: Int
    public var noteCount: Int
    public var imageCount: Int
    public var updatedAt: Date

    public init(
        deckID: String,
        title: String,
        cardCount: Int,
        noteCount: Int,
        imageCount: Int,
        updatedAt: Date
    ) {
        self.deckID = deckID
        self.title = title
        self.cardCount = cardCount
        self.noteCount = noteCount
        self.imageCount = imageCount
        self.updatedAt = updatedAt
    }
}
