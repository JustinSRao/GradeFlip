import Foundation
import GradeFlipBilling
import GradeFlipDomain

public enum SubscriptionStatus: String, Codable, Sendable {
    case inactive
    case active
    case gracePeriod
    case expired
}

public struct SubscriptionEntitlement: Codable, Equatable, Sendable {
    public var userID: UserID
    public var status: SubscriptionStatus
    public var renewalDate: Date?
    public var productID: String

    public init(
        userID: UserID,
        status: SubscriptionStatus,
        renewalDate: Date?,
        productID: String
    ) {
        self.userID = userID
        self.status = status
        self.renewalDate = renewalDate
        self.productID = productID
    }

    public func appliesOnlinePremiumCapabilities(
        to snapshot: EntitlementSnapshot
    ) -> EntitlementSnapshot {
        var updated = snapshot
        updated.hasOnlineSubscription = status == .active || status == .gracePeriod
        return updated
    }
}

public struct StudyActivityEvent: Codable, Hashable, Sendable {
    public let id: UUID
    public let userID: UserID
    public let buddyUserID: UserID?
    public let occurredOn: Date
    public let deckID: DeckID

    public init(
        id: UUID = UUID(),
        userID: UserID,
        buddyUserID: UserID? = nil,
        occurredOn: Date,
        deckID: DeckID
    ) {
        self.id = id
        self.userID = userID
        self.buddyUserID = buddyUserID
        self.occurredOn = occurredOn
        self.deckID = deckID
    }
}

public struct StudyStreak: Equatable, Sendable {
    public var userID: UserID
    public var qualifyingDays: Int
    public var lastQualifiedDay: Date?
    public var buddyUserID: UserID?

    public init(
        userID: UserID,
        qualifyingDays: Int,
        lastQualifiedDay: Date?,
        buddyUserID: UserID? = nil
    ) {
        self.userID = userID
        self.qualifyingDays = qualifyingDays
        self.lastQualifiedDay = lastQualifiedDay
        self.buddyUserID = buddyUserID
    }
}

public struct StudyStreakEngine: Sendable {
    public let calendar: Calendar

    public init(calendar: Calendar = .init(identifier: .gregorian)) {
        self.calendar = calendar
    }

    public func buildStreaks(from events: [StudyActivityEvent]) -> [StudyStreak] {
        let grouped = Dictionary(grouping: events) { StreakGroupingKey(userID: $0.userID, buddyUserID: $0.buddyUserID) }

        return grouped.map { key, groupedEvents in
            let days = groupedEvents
                .map { calendar.startOfDay(for: $0.occurredOn) }
                .sorted()
                .reduce(into: [Date]()) { acc, day in
                    if acc.last != day {
                        acc.append(day)
                    }
                }

            let qualifyingDays = countConsecutiveDays(days)

            return StudyStreak(
                userID: key.userID,
                qualifyingDays: qualifyingDays,
                lastQualifiedDay: days.last,
                buddyUserID: key.buddyUserID
            )
        }
        .sorted { lhs, rhs in
            lhs.userID.rawValue < rhs.userID.rawValue
        }
    }

    private func countConsecutiveDays(_ days: [Date]) -> Int {
        guard var current = days.last else {
            return 0
        }

        var streak = 1
        for day in days.dropLast().reversed() {
            guard let previous = calendar.date(byAdding: .day, value: -1, to: current),
                  calendar.isDate(day, inSameDayAs: previous) else {
                break
            }
            streak += 1
            current = day
        }

        return streak
    }
}

private struct StreakGroupingKey: Hashable {
    let userID: UserID
    let buddyUserID: UserID?
}
