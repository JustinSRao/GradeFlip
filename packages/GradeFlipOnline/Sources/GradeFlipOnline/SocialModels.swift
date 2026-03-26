import Foundation
import GradeFlipDomain

public enum BuddyRequestStatus: String, Codable, Sendable {
    case pending
    case accepted
    case rejected
}

public struct BuddyRequest: Codable, Sendable {
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
