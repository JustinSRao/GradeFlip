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
    public var accountState: GradeFlipAccountState

    public init(
        hasPaidCoreAccess: Bool,
        hasOnlineSubscription: Bool,
        availableStudyTokens: Int,
        accountState: GradeFlipAccountState = .anonymous
    ) {
        self.hasPaidCoreAccess = hasPaidCoreAccess
        self.hasOnlineSubscription = hasOnlineSubscription
        self.availableStudyTokens = availableStudyTokens
        self.accountState = accountState
    }

    public func hasCapability(_ capability: GradeFlipCapability) -> Bool {
        capabilityStatus(for: capability).isUnlocked
    }

    public func appMode() -> GradeFlipAppMode {
        guard hasPaidCoreAccess else {
            return .locked
        }

        if accountState == .signedIn && hasOnlineSubscription {
            return .onlineSubscriber
        }

        if accountState == .signedIn {
            return .onlineUpsell
        }

        return .offlineCore
    }

    public func capabilityStatus(for capability: GradeFlipCapability) -> GradeFlipCapabilityStatus {
        switch capability {
        case .offlineDecks:
            if hasPaidCoreAccess {
                return GradeFlipCapabilityStatus(capability: capability, isUnlocked: true, lockReason: nil)
            }
            return GradeFlipCapabilityStatus(
                capability: capability,
                isUnlocked: false,
                lockReason: .paidCoreRequired
            )
        case .onlineSync, .studyBuddies, .messaging, .friendStreaks:
            if !hasPaidCoreAccess {
                return GradeFlipCapabilityStatus(capability: capability, isUnlocked: false, lockReason: .paidCoreRequired)
            }
            if accountState != .signedIn {
                return GradeFlipCapabilityStatus(capability: capability, isUnlocked: false, lockReason: .accountRequired)
            }
            if !hasOnlineSubscription {
                return GradeFlipCapabilityStatus(
                    capability: capability,
                    isUnlocked: false,
                    lockReason: .onlineSubscriptionRequired
                )
            }
            return GradeFlipCapabilityStatus(capability: capability, isUnlocked: true, lockReason: nil)
        case .spendAITokens:
            if !hasPaidCoreAccess {
                return GradeFlipCapabilityStatus(capability: capability, isUnlocked: false, lockReason: .paidCoreRequired)
            }
            if availableStudyTokens <= 0 {
                return GradeFlipCapabilityStatus(capability: capability, isUnlocked: false, lockReason: .studyTokensRequired)
            }
            return GradeFlipCapabilityStatus(capability: capability, isUnlocked: true, lockReason: nil)
        case .webEnabledAI:
            if !hasPaidCoreAccess {
                return GradeFlipCapabilityStatus(capability: capability, isUnlocked: false, lockReason: .paidCoreRequired)
            }
            if availableStudyTokens <= 0 {
                return GradeFlipCapabilityStatus(capability: capability, isUnlocked: false, lockReason: .studyTokensRequired)
            }
            return GradeFlipCapabilityStatus(capability: capability, isUnlocked: true, lockReason: nil)
        }
    }

    public func purchaseSurface(
        for capability: GradeFlipCapability,
        catalog: GradeFlipProductCatalog = .placeholder
    ) -> GradeFlipPurchaseSurface? {
        let status = capabilityStatus(for: capability)
        guard let lockReason = status.lockReason else {
            return nil
        }

        switch lockReason {
        case .paidCoreRequired:
            return GradeFlipPurchaseSurface(
                title: "Unlock GradeFlip Core",
                message: "The paid core app unlocks offline decks, flashcards, notes, and future upgrades.",
                recommendedProducts: [catalog.paidCoreUnlock]
            )
        case .accountRequired:
            return GradeFlipPurchaseSurface(
                title: "Sign In For Online Mode",
                message: "Create or sign in to an account before using sync and social features.",
                recommendedProducts: []
            )
        case .onlineSubscriptionRequired:
            return GradeFlipPurchaseSurface(
                title: "Upgrade To GradeFlip Online",
                message: "The online subscription unlocks sync, study buddies, messaging, and friend streaks.",
                recommendedProducts: [catalog.onlineSubscriptionMonthly]
            )
        case .studyTokensRequired:
            return GradeFlipPurchaseSurface(
                title: "Buy Study Tokens",
                message: "AI features are paid from a separate study-token balance.",
                recommendedProducts: catalog.aiTokenPacks
            )
        }
    }
}
