import Foundation

public enum AnalyticsEventName: String, Codable, CaseIterable, Sendable {
    case appOpened = "app_opened"
    case deckCreated = "deck_created"
    case studySessionStarted = "study_session_started"
    case studySessionCompleted = "study_session_completed"
    case onlineSignInCompleted = "online_sign_in_completed"
    case deckSynced = "deck_synced"
    case buddyRequestSent = "buddy_request_sent"
    case subscriptionPaywallViewed = "subscription_paywall_viewed"
    case subscriptionActivated = "subscription_activated"
    case aiPromptSent = "ai_prompt_sent"
    case aiTokenEstimateViewed = "ai_token_estimate_viewed"
    case aiTokenSpendRecorded = "ai_token_spend_recorded"
}

public struct AnalyticsEvent: Codable, Hashable, Sendable {
    public var name: AnalyticsEventName
    public var occurredAt: Date
    public var metadata: [String: String]

    public init(
        name: AnalyticsEventName,
        occurredAt: Date = .now,
        metadata: [String: String] = [:]
    ) {
        self.name = name
        self.occurredAt = occurredAt
        self.metadata = metadata
    }
}
