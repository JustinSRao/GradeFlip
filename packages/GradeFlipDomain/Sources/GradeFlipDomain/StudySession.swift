import Foundation

public enum StudyCardFace: String, Codable, Sendable {
    case front
    case back
}

public enum StudySessionDirection: String, Codable, Sendable {
    case previous
    case next
}

public struct StudyCardSnapshot: Codable, Hashable, Sendable {
    public var card: Flashcard
    public var note: CardNote?
    public var images: [ImageAsset]

    public init(
        card: Flashcard,
        note: CardNote?,
        images: [ImageAsset]
    ) {
        self.card = card
        self.note = note
        self.images = images
    }
}

public struct StudyDeckSession: Codable, Hashable, Sendable {
    public let deck: Deck
    public private(set) var cards: [StudyCardSnapshot]
    public private(set) var selectedIndex: Int
    public private(set) var visibleFace: StudyCardFace

    public init(
        deck: Deck,
        cards: [StudyCardSnapshot],
        selectedIndex: Int = 0,
        visibleFace: StudyCardFace = .front
    ) {
        self.deck = deck
        self.cards = cards
        self.selectedIndex = cards.isEmpty ? 0 : min(max(selectedIndex, 0), cards.count - 1)
        self.visibleFace = visibleFace
    }

    public var selectedCard: StudyCardSnapshot? {
        guard cards.indices.contains(selectedIndex) else {
            return nil
        }
        return cards[selectedIndex]
    }

    public var progressLabel: String {
        guard !cards.isEmpty else {
            return "0 / 0"
        }
        return "\(selectedIndex + 1) / \(cards.count)"
    }

    public var notePreview: String? {
        selectedCard?.note?.plainTextContent
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .nilIfEmpty
    }

    public var canMoveBackward: Bool {
        selectedIndex > 0
    }

    public var canMoveForward: Bool {
        selectedIndex + 1 < cards.count
    }

    public mutating func flip() {
        visibleFace = visibleFace == .front ? .back : .front
    }

    public mutating func move(_ direction: StudySessionDirection) {
        switch direction {
        case .previous:
            guard canMoveBackward else { return }
            selectedIndex -= 1
        case .next:
            guard canMoveForward else { return }
            selectedIndex += 1
        }
        visibleFace = .front
    }

    public mutating func selectCard(id: FlashcardID) {
        guard let index = cards.firstIndex(where: { $0.card.id == id }) else {
            return
        }
        selectedIndex = index
        visibleFace = .front
    }
}

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}
