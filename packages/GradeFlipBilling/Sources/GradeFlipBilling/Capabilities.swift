public enum GradeFlipCapability: String, CaseIterable, Sendable {
    case offlineDecks
    case onlineSync
    case studyBuddies
    case messaging
    case friendStreaks
    case spendAITokens
    case webEnabledAI
}

public struct EntitlementSnapshot: Equatable, Sendable {
    public var hasPaidCoreAccess: Bool
    public var hasOnlineSubscription: Bool
    public var availableStudyTokens: Int

    public init(
        hasPaidCoreAccess: Bool,
        hasOnlineSubscription: Bool,
        availableStudyTokens: Int
    ) {
        self.hasPaidCoreAccess = hasPaidCoreAccess
        self.hasOnlineSubscription = hasOnlineSubscription
        self.availableStudyTokens = availableStudyTokens
    }

    public func hasCapability(_ capability: GradeFlipCapability) -> Bool {
        switch capability {
        case .offlineDecks:
            return hasPaidCoreAccess
        case .onlineSync, .studyBuddies, .messaging, .friendStreaks:
            return hasPaidCoreAccess && hasOnlineSubscription
        case .spendAITokens:
            return hasPaidCoreAccess && availableStudyTokens > 0
        case .webEnabledAI:
            return hasPaidCoreAccess && availableStudyTokens > 0
        }
    }
}
