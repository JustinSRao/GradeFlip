import Foundation
import GradeFlipDomain

public struct OnlineAccount: Codable, Hashable, Equatable, Sendable {
    public let userID: UserID
    public var emailAddress: String
    public var displayName: String
    public var createdAt: Date

    public init(
        userID: UserID = UserID(),
        emailAddress: String,
        displayName: String,
        createdAt: Date = .now
    ) {
        self.userID = userID
        self.emailAddress = emailAddress
        self.displayName = displayName
        self.createdAt = createdAt
    }
}

public struct OnlineSession: Codable, Equatable, Sendable {
    public var accountID: UserID
    public var accessToken: String
    public var refreshToken: String
    public var expiresAt: Date

    public init(
        accountID: UserID,
        accessToken: String,
        refreshToken: String,
        expiresAt: Date
    ) {
        self.accountID = accountID
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresAt = expiresAt
    }

    public func isActive(at now: Date = .now) -> Bool {
        expiresAt > now
    }
}

public struct AuthEnvelope: Codable, Equatable, Sendable {
    public var account: OnlineAccount
    public var session: OnlineSession

    public init(account: OnlineAccount, session: OnlineSession) {
        self.account = account
        self.session = session
    }
}
