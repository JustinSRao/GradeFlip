import Foundation
import GradeFlipDomain

public struct ModelPricing: Hashable, Sendable {
    public var modelID: String
    public var inputCostPerThousandTokensUSD: Double
    public var outputCostPerThousandTokensUSD: Double
    public var webModeSurchargeUSD: Double
    public var studyTokensPerUSDCent: Int

    public init(
        modelID: String,
        inputCostPerThousandTokensUSD: Double,
        outputCostPerThousandTokensUSD: Double,
        webModeSurchargeUSD: Double = 0,
        studyTokensPerUSDCent: Int = 2
    ) {
        self.modelID = modelID
        self.inputCostPerThousandTokensUSD = inputCostPerThousandTokensUSD
        self.outputCostPerThousandTokensUSD = outputCostPerThousandTokensUSD
        self.webModeSurchargeUSD = webModeSurchargeUSD
        self.studyTokensPerUSDCent = studyTokensPerUSDCent
    }
}

public struct AIPricingCatalog: Sendable {
    public var entries: [String: ModelPricing]

    public init(entries: [String: ModelPricing]) {
        self.entries = entries
    }

    public subscript(modelID: String) -> ModelPricing? {
        entries[modelID]
    }

    public static let placeholder = AIPricingCatalog(
        entries: [
            "gpt-5.4-mini": ModelPricing(modelID: "gpt-5.4-mini", inputCostPerThousandTokensUSD: 0.002, outputCostPerThousandTokensUSD: 0.008, webModeSurchargeUSD: 0.002),
            "claude-sonnet-4": ModelPricing(modelID: "claude-sonnet-4", inputCostPerThousandTokensUSD: 0.003, outputCostPerThousandTokensUSD: 0.015, webModeSurchargeUSD: 0.002),
            "gemini-2.5-pro": ModelPricing(modelID: "gemini-2.5-pro", inputCostPerThousandTokensUSD: 0.0035, outputCostPerThousandTokensUSD: 0.01, webModeSurchargeUSD: 0.0015),
            "grok-4": ModelPricing(modelID: "grok-4", inputCostPerThousandTokensUSD: 0.004, outputCostPerThousandTokensUSD: 0.012, webModeSurchargeUSD: 0.002),
            "deepseek-chat": ModelPricing(modelID: "deepseek-chat", inputCostPerThousandTokensUSD: 0.001, outputCostPerThousandTokensUSD: 0.004, webModeSurchargeUSD: 0.001),
        ]
    )
}

public enum StudyTokenLedgerEntryKind: String, Codable, Sendable {
    case purchase
    case spend
    case giftSent
    case giftReceived
    case reconciliationAdjustment
}

public struct StudyTokenLedgerEntry: Codable, Hashable, Sendable {
    public var id: UUID
    public var kind: StudyTokenLedgerEntryKind
    public var amount: Int
    public var createdAt: Date
    public var reference: String

    public init(
        id: UUID = UUID(),
        kind: StudyTokenLedgerEntryKind,
        amount: Int,
        createdAt: Date = .now,
        reference: String
    ) {
        self.id = id
        self.kind = kind
        self.amount = amount
        self.createdAt = createdAt
        self.reference = reference
    }
}

public struct StudyTokenLedger: Sendable {
    public private(set) var entries: [StudyTokenLedgerEntry]

    public init(entries: [StudyTokenLedgerEntry] = []) {
        self.entries = entries
    }

    public var balance: Int {
        entries.reduce(0) { $0 + $1.amount }
    }

    public mutating func record(_ entry: StudyTokenLedgerEntry) {
        guard !entries.contains(where: { $0.reference == entry.reference && $0.kind == entry.kind }) else {
            return
        }
        entries.append(entry)
    }
}

public struct StudyTokenGiftTransfer: Equatable, Sendable {
    public var senderEntry: StudyTokenLedgerEntry
    public var recipientEntry: StudyTokenLedgerEntry

    public init(senderEntry: StudyTokenLedgerEntry, recipientEntry: StudyTokenLedgerEntry) {
        self.senderEntry = senderEntry
        self.recipientEntry = recipientEntry
    }
}

public struct StudyTokenWallet: Sendable {
    public var ownerUserID: UserID
    public private(set) var ledger: StudyTokenLedger

    public init(ownerUserID: UserID, ledger: StudyTokenLedger = StudyTokenLedger()) {
        self.ownerUserID = ownerUserID
        self.ledger = ledger
    }

    public var balance: Int {
        ledger.balance
    }

    public mutating func record(_ entry: StudyTokenLedgerEntry) {
        ledger.record(entry)
    }

    public mutating func gift(
        amount: Int,
        to recipientUserID: UserID,
        reference: String
    ) -> StudyTokenGiftTransfer {
        let senderEntry = StudyTokenLedgerEntry(
            kind: .giftSent,
            amount: -amount,
            reference: "\(reference):\(ownerUserID.rawValue):\(recipientUserID.rawValue):sent"
        )
        let recipientEntry = StudyTokenLedgerEntry(
            kind: .giftReceived,
            amount: amount,
            reference: "\(reference):\(ownerUserID.rawValue):\(recipientUserID.rawValue):received"
        )
        ledger.record(senderEntry)

        return StudyTokenGiftTransfer(senderEntry: senderEntry, recipientEntry: recipientEntry)
    }
}

public struct StudyTokenEstimator: Sendable {
    public let pricingCatalog: AIPricingCatalog

    public init(pricingCatalog: AIPricingCatalog) {
        self.pricingCatalog = pricingCatalog
    }

    public func estimate(for request: AIChatRequest) -> AIUsageEstimate {
        let inputText = request.messages.map(\.content).joined(separator: "\n") + (request.grounding?.promptContext ?? "")
        let inputTokens = estimateTokenCount(for: inputText)
        let charge = studyTokenCharge(
            modelID: request.model.modelID,
            mode: request.mode,
            inputTokens: inputTokens,
            outputTokens: request.reservedOutputTokens
        )

        return AIUsageEstimate(
            inputTokens: inputTokens,
            reservedOutputTokens: request.reservedOutputTokens,
            estimatedStudyTokenCharge: charge
        )
    }

    public func reconcile(
        estimate: AIUsageEstimate,
        modelID: String,
        mode: AIChatMode,
        actualInputTokens: Int,
        actualOutputTokens: Int
    ) -> AIUsageReconciliation {
        let finalCharge = studyTokenCharge(
            modelID: modelID,
            mode: mode,
            inputTokens: actualInputTokens,
            outputTokens: actualOutputTokens
        )

        return AIUsageReconciliation(
            actualInputTokens: actualInputTokens,
            actualOutputTokens: actualOutputTokens,
            finalStudyTokenCharge: finalCharge,
            adjustment: finalCharge - estimate.estimatedStudyTokenCharge
        )
    }

    public func estimateTokenCount(for text: String) -> Int {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return 0 }
        return max(Int(ceil(Double(trimmed.count) / 4.0)), 1)
    }

    private func studyTokenCharge(
        modelID: String,
        mode: AIChatMode,
        inputTokens: Int,
        outputTokens: Int
    ) -> Int {
        guard let pricing = pricingCatalog[modelID] else {
            return 0
        }

        let inputUSD = (Double(inputTokens) / 1000.0) * pricing.inputCostPerThousandTokensUSD
        let outputUSD = (Double(outputTokens) / 1000.0) * pricing.outputCostPerThousandTokensUSD
        let surcharge = mode == .webEnabled ? pricing.webModeSurchargeUSD : 0
        let usdCents = (inputUSD + outputUSD + surcharge) * 100.0
        let tokens = Int(ceil(usdCents)) * pricing.studyTokensPerUSDCent
        return max(tokens, 1)
    }
}
