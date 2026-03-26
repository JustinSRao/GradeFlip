import Foundation

public enum AIProvider: String, CaseIterable, Sendable {
    case openAI
    case anthropic
    case gemini
    case grok
    case deepSeek
}

public enum AIChatMode: String, Sendable {
    case deckGrounded
    case webEnabled
}

public struct AIUsageEstimate: Equatable, Sendable {
    public var inputTokens: Int
    public var reservedOutputTokens: Int
    public var estimatedStudyTokenCharge: Int

    public init(
        inputTokens: Int,
        reservedOutputTokens: Int,
        estimatedStudyTokenCharge: Int
    ) {
        self.inputTokens = inputTokens
        self.reservedOutputTokens = reservedOutputTokens
        self.estimatedStudyTokenCharge = estimatedStudyTokenCharge
    }
}
