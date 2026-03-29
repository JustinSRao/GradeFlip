import Foundation
import GradeFlipDomain

public enum LocalDeckLibraryError: Error, Equatable, Sendable {
    case missingFlashcard(FlashcardID)
}

public final class LocalDeckLibrary: Sendable {
    public let store: LocalDeckFileStore
    private let fileManager: FileManager

    public init(
        store: LocalDeckFileStore,
        fileManager: FileManager = .default
    ) {
        self.store = store
        self.fileManager = fileManager
    }

    public func listDecks() throws -> [LocalDeckIndexSnapshot] {
        try store.bootstrapStorageRoot()

        let decksRoot = store.configuration.rootURL
            .appendingPathComponent(LocalDeckLayout.decksDirectoryName, isDirectory: true)
        guard fileManager.fileExists(atPath: decksRoot.path) else {
            return []
        }

        let deckDirectories = try fileManager.contentsOfDirectory(
            at: decksRoot,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )

        return try deckDirectories.compactMap { directory in
            guard let deckID = DeckID(rawValue: directory.lastPathComponent) else {
                return nil
            }
            let snapshot = try store.load(deckID: deckID)
            return store.makeIndexSnapshot(for: snapshot)
        }
        .sorted { $0.updatedAt > $1.updatedAt }
    }

    @discardableResult
    public func createDeck(title: String) throws -> LocalDeckSnapshot {
        let now = Date()
        let deck = Deck(title: title, createdAt: now, updatedAt: now)
        let snapshot = LocalDeckSnapshot(
            contents: StoredDeckContents(deck: deck, cards: [], imageAssets: [], savedAt: now),
            notes: StoredDeckNotes(deckID: deck.id, notes: [], savedAt: now)
        )
        try store.save(snapshot: snapshot)
        return snapshot
    }

    @discardableResult
    public func renameDeck(deckID: DeckID, title: String) throws -> LocalDeckSnapshot {
        var snapshot = try store.load(deckID: deckID)
        snapshot.contents.deck.title = title
        snapshot.contents.deck.updatedAt = .now
        snapshot.contents.savedAt = .now
        try store.save(snapshot: snapshot)
        return snapshot
    }

    public func deleteDeck(deckID: DeckID) throws {
        let deckDirectory = LocalDeckLayout.deckDirectory(for: deckID, root: store.configuration.rootURL)
        guard fileManager.fileExists(atPath: deckDirectory.path) else {
            return
        }
        try fileManager.removeItem(at: deckDirectory)
    }

    @discardableResult
    public func createFlashcard(
        in deckID: DeckID,
        frontText: String,
        backText: String
    ) throws -> LocalDeckSnapshot {
        var snapshot = try store.load(deckID: deckID)
        let card = Flashcard(deckID: deckID, frontText: frontText, backText: backText)
        snapshot.contents.cards.append(card)
        snapshot.contents.deck.updatedAt = .now
        snapshot.contents.savedAt = .now
        try store.save(snapshot: snapshot)
        return snapshot
    }

    @discardableResult
    public func updateFlashcard(
        deckID: DeckID,
        flashcardID: FlashcardID,
        frontText: String,
        backText: String
    ) throws -> LocalDeckSnapshot {
        var snapshot = try store.load(deckID: deckID)
        guard let index = snapshot.contents.cards.firstIndex(where: { $0.id == flashcardID }) else {
            throw LocalDeckLibraryError.missingFlashcard(flashcardID)
        }

        snapshot.contents.cards[index].frontText = frontText
        snapshot.contents.cards[index].backText = backText
        snapshot.contents.deck.updatedAt = .now
        snapshot.contents.savedAt = .now
        try store.save(snapshot: snapshot)
        return snapshot
    }

    @discardableResult
    public func deleteFlashcard(
        deckID: DeckID,
        flashcardID: FlashcardID
    ) throws -> LocalDeckSnapshot {
        var snapshot = try store.load(deckID: deckID)
        guard snapshot.contents.cards.contains(where: { $0.id == flashcardID }) else {
            throw LocalDeckLibraryError.missingFlashcard(flashcardID)
        }

        snapshot.contents.cards.removeAll { $0.id == flashcardID }
        snapshot.notes.notes.removeAll { $0.flashcardID == flashcardID }
        snapshot.contents.imageAssets.removeAll { $0.flashcardID == flashcardID }
        snapshot.contents.deck.updatedAt = .now
        snapshot.contents.savedAt = .now
        snapshot.notes.savedAt = .now
        try store.save(snapshot: snapshot)
        return snapshot
    }
}
