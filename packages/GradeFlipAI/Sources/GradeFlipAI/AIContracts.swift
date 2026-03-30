import Foundation
import GradeFlipDomain
import GradeFlipStorage

public enum AIProvider: String, CaseIterable, Codable, Sendable {
    case openAI
    case anthropic
    case gemini
    case grok
    case deepSeek
}

public enum AIChatMode: String, Codable, Sendable {
    case deckGrounded
    case webEnabled
}

public enum AIMessageRole: String, Codable, Sendable {
    case system
    case user
    case assistant
}

public struct AIModelDescriptor: Codable, Hashable, Sendable {
    public var provider: AIProvider
    public var modelID: String
    public var displayName: String
    public var supportsDeckGrounding: Bool
    public var supportsWebMode: Bool

    public init(
        provider: AIProvider,
        modelID: String,
        displayName: String,
        supportsDeckGrounding: Bool,
        supportsWebMode: Bool
    ) {
        self.provider = provider
        self.modelID = modelID
        self.displayName = displayName
        self.supportsDeckGrounding = supportsDeckGrounding
        self.supportsWebMode = supportsWebMode
    }
}

public struct AIChatMessage: Codable, Hashable, Sendable {
    public var role: AIMessageRole
    public var content: String

    public init(role: AIMessageRole, content: String) {
        self.role = role
        self.content = content
    }
}

public struct DeckGroundingPackage: Codable, Hashable, Sendable {
    public var selectedDeckIDs: [DeckID]
    public var promptContext: String
    public var sourceCardCount: Int

    public init(
        selectedDeckIDs: [DeckID],
        promptContext: String,
        sourceCardCount: Int
    ) {
        self.selectedDeckIDs = selectedDeckIDs
        self.promptContext = promptContext
        self.sourceCardCount = sourceCardCount
    }
}

public struct AIChatRequest: Codable, Hashable, Sendable {
    public var mode: AIChatMode
    public var model: AIModelDescriptor
    public var messages: [AIChatMessage]
    public var grounding: DeckGroundingPackage?
    public var reservedOutputTokens: Int

    public init(
        mode: AIChatMode,
        model: AIModelDescriptor,
        messages: [AIChatMessage],
        grounding: DeckGroundingPackage?,
        reservedOutputTokens: Int
    ) {
        self.mode = mode
        self.model = model
        self.messages = messages
        self.grounding = grounding
        self.reservedOutputTokens = reservedOutputTokens
    }
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

public struct AIUsageReconciliation: Equatable, Sendable {
    public var actualInputTokens: Int
    public var actualOutputTokens: Int
    public var finalStudyTokenCharge: Int
    public var adjustment: Int

    public init(
        actualInputTokens: Int,
        actualOutputTokens: Int,
        finalStudyTokenCharge: Int,
        adjustment: Int
    ) {
        self.actualInputTokens = actualInputTokens
        self.actualOutputTokens = actualOutputTokens
        self.finalStudyTokenCharge = finalStudyTokenCharge
        self.adjustment = adjustment
    }
}

public struct DeckGroundingBuilder: Sendable {
    public init() {}

    public func makeGroundingPackage(
        from snapshots: [LocalDeckSnapshot],
        selectedDeckIDs: [DeckID]
    ) -> DeckGroundingPackage {
        let selectedSnapshots = snapshots.filter { selectedDeckIDs.contains($0.contents.deck.id) }
        let contextLines = selectedSnapshots.flatMap { snapshot -> [String] in
            let deckTitle = snapshot.contents.deck.title
            return snapshot.contents.cards.map { card in
                let note = snapshot.notes.notes.first(where: { $0.flashcardID == card.id })?.plainTextContent ?? ""
                return "Deck: \(deckTitle)\nFront: \(card.frontText)\nBack: \(card.backText)\nNote: \(note)"
            }
        }

        return DeckGroundingPackage(
            selectedDeckIDs: selectedDeckIDs,
            promptContext: contextLines.joined(separator: "\n\n"),
            sourceCardCount: contextLines.count
        )
    }
}
