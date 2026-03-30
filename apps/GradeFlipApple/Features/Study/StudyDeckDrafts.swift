import Foundation

struct StudyDeckDraft: Identifiable, Hashable {
    let id: UUID
    var title: String
    var cards: [StudyCardDraft]

    init(id: UUID = UUID(), title: String, cards: [StudyCardDraft]) {
        self.id = id
        self.title = title
        self.cards = cards
    }

    static let sampleDecks: [StudyDeckDraft] = [
        StudyDeckDraft(
            title: "Biology Sprint Review",
            cards: [
                StudyCardDraft(
                    frontText: "What does the mitochondrion do?",
                    backText: "Produces ATP and supports cellular respiration.",
                    noteText: "Focus on ATP wording for tests.",
                    images: [ImageDraft(filename: "cell-diagram.png", tintName: "green")]
                ),
                StudyCardDraft(
                    frontText: "What is osmosis?",
                    backText: "Movement of water across a semipermeable membrane.",
                    noteText: "Remember passive transport.",
                    images: []
                ),
            ]
        ),
        StudyDeckDraft(
            title: "US History",
            cards: [
                StudyCardDraft(
                    frontText: "When was the Constitution ratified?",
                    backText: "1788.",
                    noteText: "Federalist Papers context matters.",
                    images: [ImageDraft(filename: "constitution-notes.jpg", tintName: "orange")]
                ),
            ]
        ),
    ]
}

struct StudyCardDraft: Identifiable, Hashable {
    let id: UUID
    var frontText: String
    var backText: String
    var noteText: String
    var images: [ImageDraft]
    var isStarred: Bool

    init(
        id: UUID = UUID(),
        frontText: String,
        backText: String,
        noteText: String = "",
        images: [ImageDraft] = [],
        isStarred: Bool = false
    ) {
        self.id = id
        self.frontText = frontText
        self.backText = backText
        self.noteText = noteText
        self.images = images
        self.isStarred = isStarred
    }
}
