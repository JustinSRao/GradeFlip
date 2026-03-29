import Foundation

struct DeckDraft: Identifiable, Hashable {
    let id: UUID
    var title: String
    var cards: [CardDraft]

    init(id: UUID = UUID(), title: String, cards: [CardDraft]) {
        self.id = id
        self.title = title
        self.cards = cards
    }

    static let sampleDecks: [DeckDraft] = [
        DeckDraft(
            title: "Biology",
            cards: [
                CardDraft(frontText: "Cell", backText: "Basic unit of life"),
                CardDraft(frontText: "DNA", backText: "Genetic material"),
            ]
        ),
        DeckDraft(
            title: "History",
            cards: [
                CardDraft(frontText: "1776", backText: "US Declaration of Independence"),
            ]
        ),
    ]
}

struct CardDraft: Identifiable, Hashable {
    let id: UUID
    var frontText: String
    var backText: String

    init(id: UUID = UUID(), frontText: String, backText: String) {
        self.id = id
        self.frontText = frontText
        self.backText = backText
    }
}
