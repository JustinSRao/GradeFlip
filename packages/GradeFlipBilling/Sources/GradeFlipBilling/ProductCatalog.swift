public enum GradeFlipAccountState: String, Codable, CaseIterable, Sendable {
    case anonymous
    case signedIn
}

public enum GradeFlipAppMode: String, Codable, CaseIterable, Sendable {
    case locked
    case offlineCore
    case onlineUpsell
    case onlineSubscriber
}

public enum GradeFlipStoreProductKind: String, Codable, CaseIterable, Sendable {
    case paidCoreUnlock
    case onlineSubscription
    case aiTokenPack
}

public struct GradeFlipStoreProduct: Codable, Hashable, Sendable {
    public var id: String
    public var kind: GradeFlipStoreProductKind
    public var displayName: String
    public var tokenAmount: Int?
    public var isPlaceholder: Bool

    public init(
        id: String,
        kind: GradeFlipStoreProductKind,
        displayName: String,
        tokenAmount: Int? = nil,
        isPlaceholder: Bool = true
    ) {
        self.id = id
        self.kind = kind
        self.displayName = displayName
        self.tokenAmount = tokenAmount
        self.isPlaceholder = isPlaceholder
    }
}

public struct GradeFlipProductCatalog: Codable, Hashable, Sendable {
    public var paidCoreUnlock: GradeFlipStoreProduct
    public var onlineSubscriptionMonthly: GradeFlipStoreProduct
    public var aiTokenPacks: [GradeFlipStoreProduct]

    public init(
        paidCoreUnlock: GradeFlipStoreProduct,
        onlineSubscriptionMonthly: GradeFlipStoreProduct,
        aiTokenPacks: [GradeFlipStoreProduct]
    ) {
        self.paidCoreUnlock = paidCoreUnlock
        self.onlineSubscriptionMonthly = onlineSubscriptionMonthly
        self.aiTokenPacks = aiTokenPacks
    }

    public static let placeholder = GradeFlipProductCatalog(
        paidCoreUnlock: GradeFlipStoreProduct(
            id: "com.gradeflip.app.core",
            kind: .paidCoreUnlock,
            displayName: "GradeFlip Core Unlock"
        ),
        onlineSubscriptionMonthly: GradeFlipStoreProduct(
            id: "com.gradeflip.subscription.online.monthly",
            kind: .onlineSubscription,
            displayName: "GradeFlip Online Monthly"
        ),
        aiTokenPacks: [
            GradeFlipStoreProduct(
                id: "com.gradeflip.tokens.study.25",
                kind: .aiTokenPack,
                displayName: "25 Study Tokens",
                tokenAmount: 25
            ),
            GradeFlipStoreProduct(
                id: "com.gradeflip.tokens.study.100",
                kind: .aiTokenPack,
                displayName: "100 Study Tokens",
                tokenAmount: 100
            ),
        ]
    )
}

public enum GradeFlipCapabilityLockReason: String, Codable, CaseIterable, Sendable {
    case paidCoreRequired
    case accountRequired
    case onlineSubscriptionRequired
    case studyTokensRequired
}

public struct GradeFlipCapabilityStatus: Hashable, Sendable {
    public var capability: GradeFlipCapability
    public var isUnlocked: Bool
    public var lockReason: GradeFlipCapabilityLockReason?

    public init(
        capability: GradeFlipCapability,
        isUnlocked: Bool,
        lockReason: GradeFlipCapabilityLockReason?
    ) {
        self.capability = capability
        self.isUnlocked = isUnlocked
        self.lockReason = lockReason
    }
}
