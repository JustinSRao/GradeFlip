import Foundation

public struct AIProviderCatalog: Sendable {
    public let models: [AIModelDescriptor]

    public init(models: [AIModelDescriptor]) {
        self.models = models
    }

    public func models(for provider: AIProvider) -> [AIModelDescriptor] {
        models.filter { $0.provider == provider }
    }

    public static let `default` = AIProviderCatalog(
        models: [
            AIModelDescriptor(provider: .openAI, modelID: "gpt-5.4-mini", displayName: "GPT-5.4 Mini", supportsDeckGrounding: true, supportsWebMode: true),
            AIModelDescriptor(provider: .anthropic, modelID: "claude-sonnet-4", displayName: "Claude Sonnet 4", supportsDeckGrounding: true, supportsWebMode: true),
            AIModelDescriptor(provider: .gemini, modelID: "gemini-2.5-pro", displayName: "Gemini 2.5 Pro", supportsDeckGrounding: true, supportsWebMode: true),
            AIModelDescriptor(provider: .grok, modelID: "grok-4", displayName: "Grok 4", supportsDeckGrounding: true, supportsWebMode: true),
            AIModelDescriptor(provider: .deepSeek, modelID: "deepseek-chat", displayName: "DeepSeek Chat", supportsDeckGrounding: true, supportsWebMode: true),
        ]
    )
}
