import Foundation
import GradeFlipDomain

public enum BuddyRequestStatus: String, Codable, Sendable {
    case pending
    case accepted
    case rejected
}

public struct BuddyRequest: Codable, Hashable, Sendable {
    public let id: UUID
    public let fromUserID: UserID
    public let toUserID: UserID
    public var status: BuddyRequestStatus
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        fromUserID: UserID,
        toUserID: UserID,
        status: BuddyRequestStatus = .pending,
        createdAt: Date = .now
    ) {
        self.id = id
        self.fromUserID = fromUserID
        self.toUserID = toUserID
        self.status = status
        self.createdAt = createdAt
    }
}

public struct StudyBuddyRelationship: Codable, Hashable, Sendable {
    public let id: UUID
    public let userIDs: Set<UserID>
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        userIDs: Set<UserID>,
        createdAt: Date = .now
    ) {
        self.id = id
        self.userIDs = userIDs
        self.createdAt = createdAt
    }
}

public enum SocialEventKind: String, Codable, Sendable {
    case buddyRequest
    case buddyAccepted
    case deckShare
    case deckRequest
    case deckLike
    case tokenGift
}

public struct SharedDeckAccess: Codable, Hashable, Sendable {
    public let deckID: DeckID
    public let ownerUserID: UserID
    public let recipientUserID: UserID
    public let canCopyToLibrary: Bool
    public let createdAt: Date

    public init(
        deckID: DeckID,
        ownerUserID: UserID,
        recipientUserID: UserID,
        canCopyToLibrary: Bool,
        createdAt: Date = .now
    ) {
        self.deckID = deckID
        self.ownerUserID = ownerUserID
        self.recipientUserID = recipientUserID
        self.canCopyToLibrary = canCopyToLibrary
        self.createdAt = createdAt
    }
}

public struct DeckLike: Codable, Hashable, Sendable {
    public let id: UUID
    public let deckID: DeckID
    public let fromUserID: UserID
    public let ownerUserID: UserID
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        deckID: DeckID,
        fromUserID: UserID,
        ownerUserID: UserID,
        createdAt: Date = .now
    ) {
        self.id = id
        self.deckID = deckID
        self.fromUserID = fromUserID
        self.ownerUserID = ownerUserID
        self.createdAt = createdAt
    }
}

public struct SocialEvent: Codable, Hashable, Sendable {
    public let id: UUID
    public let kind: SocialEventKind
    public let actorUserID: UserID
    public let targetUserID: UserID
    public let deckID: DeckID?
    public let message: String
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        kind: SocialEventKind,
        actorUserID: UserID,
        targetUserID: UserID,
        deckID: DeckID? = nil,
        message: String,
        createdAt: Date = .now
    ) {
        self.id = id
        self.kind = kind
        self.actorUserID = actorUserID
        self.targetUserID = targetUserID
        self.deckID = deckID
        self.message = message
        self.createdAt = createdAt
    }
}

public struct SocialGraph: Sendable {
    public private(set) var requests: [BuddyRequest]
    public private(set) var relationships: [StudyBuddyRelationship]
    public private(set) var events: [SocialEvent]
    public private(set) var sharedDecks: [SharedDeckAccess]
    public private(set) var likes: [DeckLike]

    public init(
        requests: [BuddyRequest] = [],
        relationships: [StudyBuddyRelationship] = [],
        events: [SocialEvent] = [],
        sharedDecks: [SharedDeckAccess] = [],
        likes: [DeckLike] = []
    ) {
        self.requests = requests
        self.relationships = relationships
        self.events = events
        self.sharedDecks = sharedDecks
        self.likes = likes
    }

    public mutating func sendBuddyRequest(from actor: UserID, to recipient: UserID) -> BuddyRequest {
        let request = BuddyRequest(fromUserID: actor, toUserID: recipient)
        requests.append(request)
        events.append(
            SocialEvent(
                kind: .buddyRequest,
                actorUserID: actor,
                targetUserID: recipient,
                message: "Study buddy request sent."
            )
        )
        return request
    }

    public mutating func respondToBuddyRequest(_ requestID: UUID, accept: Bool) {
        guard let index = requests.firstIndex(where: { $0.id == requestID }) else {
            return
        }

        requests[index].status = accept ? .accepted : .rejected
        if accept {
            relationships.append(
                StudyBuddyRelationship(
                    userIDs: [requests[index].fromUserID, requests[index].toUserID]
                )
            )
            events.append(
                SocialEvent(
                    kind: .buddyAccepted,
                    actorUserID: requests[index].toUserID,
                    targetUserID: requests[index].fromUserID,
                    message: "Study buddy request accepted."
                )
            )
        }
    }

    public mutating func shareDeck(
        deckID: DeckID,
        from owner: UserID,
        to recipient: UserID,
        canCopyToLibrary: Bool
    ) {
        sharedDecks.append(
            SharedDeckAccess(
                deckID: deckID,
                ownerUserID: owner,
                recipientUserID: recipient,
                canCopyToLibrary: canCopyToLibrary
            )
        )
        events.append(
            SocialEvent(
                kind: .deckShare,
                actorUserID: owner,
                targetUserID: recipient,
                deckID: deckID,
                message: "Deck shared with buddy."
            )
        )
    }

    public mutating func requestDeck(deckID: DeckID, from actor: UserID, to recipient: UserID) {
        events.append(
            SocialEvent(
                kind: .deckRequest,
                actorUserID: actor,
                targetUserID: recipient,
                deckID: deckID,
                message: "Deck requested from buddy."
            )
        )
    }

    public mutating func likeDeck(deckID: DeckID, from actor: UserID, to owner: UserID) {
        likes.append(DeckLike(deckID: deckID, fromUserID: actor, ownerUserID: owner))
        events.append(
            SocialEvent(
                kind: .deckLike,
                actorUserID: actor,
                targetUserID: owner,
                deckID: deckID,
                message: "Deck liked."
            )
        )
    }
}
