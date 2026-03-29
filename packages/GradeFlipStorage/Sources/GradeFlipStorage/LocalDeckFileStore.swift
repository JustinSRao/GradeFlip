import Foundation
import GradeFlipDomain

public enum LocalDeckStoreError: Error, Equatable, Sendable {
    case missingDeck(DeckID)
    case invalidImageFileExtension
    case imageNotFound(ImageAssetID)
}

public final class LocalDeckFileStore: Sendable {
    public let configuration: LocalDeckStorageConfiguration
    private let fileManager: FileManager
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(
        configuration: LocalDeckStorageConfiguration,
        fileManager: FileManager = .default
    ) {
        self.configuration = configuration
        self.fileManager = fileManager

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        self.encoder = encoder

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    public func bootstrapStorageRoot() throws {
        let decksRoot = configuration.rootURL
            .appendingPathComponent(LocalDeckLayout.decksDirectoryName, isDirectory: true)
        try fileManager.createDirectory(at: decksRoot, withIntermediateDirectories: true)
        try applyProtectionIfAvailable(to: decksRoot)
    }

    public func save(snapshot: LocalDeckSnapshot) throws {
        try bootstrapStorageRoot()

        let deckID = snapshot.contents.deck.id
        let deckDirectory = LocalDeckLayout.deckDirectory(for: deckID, root: configuration.rootURL)
        let imagesDirectory = LocalDeckLayout.imagesDirectoryURL(for: deckID, root: configuration.rootURL)

        try fileManager.createDirectory(at: deckDirectory, withIntermediateDirectories: true)
        try fileManager.createDirectory(at: imagesDirectory, withIntermediateDirectories: true)
        try applyProtectionIfAvailable(to: deckDirectory)
        try applyProtectionIfAvailable(to: imagesDirectory)

        let encodedContents = try encoder.encode(snapshot.contents)
        let encodedNotes = try encoder.encode(snapshot.notes)

        try atomicWrite(encodedContents, to: LocalDeckLayout.cardsFileURL(for: deckID, root: configuration.rootURL))
        try atomicWrite(encodedNotes, to: LocalDeckLayout.notesFileURL(for: deckID, root: configuration.rootURL))
    }

    public func load(deckID: DeckID) throws -> LocalDeckSnapshot {
        let cardsURL = LocalDeckLayout.cardsFileURL(for: deckID, root: configuration.rootURL)
        let notesURL = LocalDeckLayout.notesFileURL(for: deckID, root: configuration.rootURL)

        guard fileManager.fileExists(atPath: cardsURL.path) else {
            throw LocalDeckStoreError.missingDeck(deckID)
        }

        let contentsData = try Data(contentsOf: cardsURL)
        let notesData: Data
        if fileManager.fileExists(atPath: notesURL.path) {
            notesData = try Data(contentsOf: notesURL)
        } else {
            notesData = try encoder.encode(StoredDeckNotes(deckID: deckID))
        }

        let contents = try decoder.decode(StoredDeckContents.self, from: contentsData)
        let notes = try decoder.decode(StoredDeckNotes.self, from: notesData)
        return LocalDeckSnapshot(contents: contents, notes: notes)
    }

    public func makeIndexSnapshot(for snapshot: LocalDeckSnapshot) -> LocalDeckIndexSnapshot {
        LocalDeckIndexSnapshot(
            deckID: snapshot.contents.deck.id.rawValue,
            title: snapshot.contents.deck.title,
            cardCount: snapshot.contents.cards.count,
            noteCount: snapshot.notes.notes.count,
            imageCount: snapshot.contents.imageAssets.count,
            updatedAt: snapshot.contents.deck.updatedAt
        )
    }

    public func storeImage(
        _ data: Data,
        for deckID: DeckID,
        flashcardID: FlashcardID,
        originalFilename: String?
    ) throws -> ImageAsset {
        let imageAssetID = ImageAssetID()
        let canonicalFilename = try Self.canonicalImageFilename(
            for: imageAssetID,
            originalFilename: originalFilename
        )
        let image = ImageAsset(
            id: imageAssetID,
            deckID: deckID,
            flashcardID: flashcardID,
            canonicalFilename: canonicalFilename,
            originalFilename: originalFilename
        )
        let destination = LocalDeckLayout
            .imagesDirectoryURL(for: deckID, root: configuration.rootURL)
            .appendingPathComponent(canonicalFilename, isDirectory: false)

        try fileManager.createDirectory(
            at: LocalDeckLayout.imagesDirectoryURL(for: deckID, root: configuration.rootURL),
            withIntermediateDirectories: true
        )
        try atomicWrite(data, to: destination)
        return image
    }

    public func deleteImage(_ imageAsset: ImageAsset) throws {
        let imageURL = LocalDeckLayout
            .imagesDirectoryURL(for: imageAsset.deckID, root: configuration.rootURL)
            .appendingPathComponent(imageAsset.canonicalFilename, isDirectory: false)

        guard fileManager.fileExists(atPath: imageURL.path) else {
            throw LocalDeckStoreError.imageNotFound(imageAsset.id)
        }

        try fileManager.removeItem(at: imageURL)
    }

    public static func canonicalImageFilename(
        for imageAssetID: ImageAssetID,
        originalFilename: String?
    ) throws -> String {
        let fileExtension = (originalFilename as NSString?)?.pathExtension.lowercased() ?? ""
        guard !fileExtension.isEmpty else {
            throw LocalDeckStoreError.invalidImageFileExtension
        }

        return "\(imageAssetID.rawValue).\(fileExtension)"
    }

    private func atomicWrite(_ data: Data, to destinationURL: URL) throws {
        let directory = destinationURL.deletingLastPathComponent()
        try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)

        let tempURL = directory.appendingPathComponent("\(UUID().uuidString).tmp", isDirectory: false)
        try data.write(to: tempURL, options: .atomic)

        if fileManager.fileExists(atPath: destinationURL.path) {
            #if os(Windows)
            try fileManager.removeItem(at: destinationURL)
            try fileManager.moveItem(at: tempURL, to: destinationURL)
            #else
            _ = try fileManager.replaceItemAt(destinationURL, withItemAt: tempURL)
            #endif
        } else {
            try fileManager.moveItem(at: tempURL, to: destinationURL)
        }

        try applyProtectionIfAvailable(to: destinationURL)
    }

    private func applyProtectionIfAvailable(to url: URL) throws {
        #if canImport(Darwin)
        guard configuration.protection == .completeUntilFirstUserAuthentication else {
            return
        }

        var values = URLResourceValues()
        values.fileProtection = .completeUntilFirstUserAuthentication
        var mutableURL = url
        try mutableURL.setResourceValues(values)
        #else
        _ = url
        #endif
    }
}
