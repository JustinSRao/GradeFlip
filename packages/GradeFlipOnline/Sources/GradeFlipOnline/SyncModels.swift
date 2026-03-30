import Foundation
import GradeFlipDomain
import GradeFlipStorage

public enum SyncConflictResolution: String, Codable, Sendable {
    case keepLocal
    case keepRemote
    case mergePreservingIdentifiers
}

public struct CloudDeckRecord: Codable, Hashable, Sendable {
    public var deck: Deck
    public var cards: [Flashcard]
    public var notes: [CardNote]
    public var imageAssets: [ImageAsset]
    public var ownerUserID: UserID
    public var updatedAt: Date

    public init(
        deck: Deck,
        cards: [Flashcard],
        notes: [CardNote],
        imageAssets: [ImageAsset],
        ownerUserID: UserID,
        updatedAt: Date
    ) {
        self.deck = deck
        self.cards = cards
        self.notes = notes
        self.imageAssets = imageAssets
        self.ownerUserID = ownerUserID
        self.updatedAt = updatedAt
    }
}

public struct SyncConflict: Equatable, Sendable {
    public var deckID: String
    public var localUpdatedAt: Date
    public var remoteUpdatedAt: Date
    public var suggestedResolution: SyncConflictResolution

    public init(
        deckID: String,
        localUpdatedAt: Date,
        remoteUpdatedAt: Date,
        suggestedResolution: SyncConflictResolution
    ) {
        self.deckID = deckID
        self.localUpdatedAt = localUpdatedAt
        self.remoteUpdatedAt = remoteUpdatedAt
        self.suggestedResolution = suggestedResolution
    }
}

public struct SyncPlan: Equatable, Sendable {
    public var decksToUpload: [String]
    public var decksToDownload: [String]
    public var conflicts: [SyncConflict]

    public init(
        decksToUpload: [String],
        decksToDownload: [String],
        conflicts: [SyncConflict]
    ) {
        self.decksToUpload = decksToUpload
        self.decksToDownload = decksToDownload
        self.conflicts = conflicts
    }
}

public struct DeckSyncPlanner: Sendable {
    public init() {}

    public func plan(
        localDecks: [LocalDeckIndexSnapshot],
        remoteDecks: [CloudDeckRecord]
    ) -> SyncPlan {
        let localByID = Dictionary(uniqueKeysWithValues: localDecks.map { ($0.deckID, $0) })
        let remoteByID = Dictionary(uniqueKeysWithValues: remoteDecks.map { ($0.deck.id.rawValue, $0) })

        var uploads: [String] = []
        var downloads: [String] = []
        var conflicts: [SyncConflict] = []

        for (deckID, localDeck) in localByID {
            guard let remoteDeck = remoteByID[deckID] else {
                uploads.append(deckID)
                continue
            }

            if localDeck.updatedAt == remoteDeck.updatedAt {
                continue
            }

            let skew = abs(localDeck.updatedAt.timeIntervalSince(remoteDeck.updatedAt))
            if skew < 5 {
                conflicts.append(
                    SyncConflict(
                        deckID: deckID,
                        localUpdatedAt: localDeck.updatedAt,
                        remoteUpdatedAt: remoteDeck.updatedAt,
                        suggestedResolution: .mergePreservingIdentifiers
                    )
                )
            } else if localDeck.updatedAt > remoteDeck.updatedAt {
                uploads.append(deckID)
            } else {
                downloads.append(deckID)
            }
        }

        for (deckID, remoteDeck) in remoteByID where localByID[deckID] == nil {
            downloads.append(remoteDeck.deck.id.rawValue)
        }

        let sortedUploads = uploads.sorted()
        let sortedDownloads = downloads.sorted()
        let sortedConflicts = conflicts.sorted { $0.deckID < $1.deckID }

        return SyncPlan(
            decksToUpload: sortedUploads,
            decksToDownload: sortedDownloads,
            conflicts: sortedConflicts
        )
    }
}
