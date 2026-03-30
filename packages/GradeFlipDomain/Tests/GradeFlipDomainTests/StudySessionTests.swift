import XCTest
@testable import GradeFlipDomain

final class StudySessionTests: XCTestCase {
    func testFlipTogglesBetweenFrontAndBack() {
        var session = makeSession()

        XCTAssertEqual(session.visibleFace, .front)
        session.flip()
        XCTAssertEqual(session.visibleFace, .back)
        session.flip()
        XCTAssertEqual(session.visibleFace, .front)
    }

    func testMoveResetsVisibleFaceToFront() {
        var session = makeSession()

        session.flip()
        session.move(.next)

        XCTAssertEqual(session.progressLabel, "2 / 2")
        XCTAssertEqual(session.visibleFace, .front)
    }

    func testSelectCardUpdatesSelectedIndex() {
        var session = makeSession()
        let targetID = session.cards[1].card.id

        session.selectCard(id: targetID)

        XCTAssertEqual(session.selectedCard?.card.id, targetID)
        XCTAssertEqual(session.progressLabel, "2 / 2")
    }

    func testNotePreviewTrimsWhitespace() {
        let session = makeSession()

        XCTAssertEqual(session.notePreview, "Trimmed note")
    }

    private func makeSession() -> StudyDeckSession {
        let deck = Deck(title: "Biology")
        let firstCard = Flashcard(deckID: deck.id, frontText: "Front A", backText: "Back A")
        let secondCard = Flashcard(deckID: deck.id, frontText: "Front B", backText: "Back B")

        return StudyDeckSession(
            deck: deck,
            cards: [
                StudyCardSnapshot(
                    card: firstCard,
                    note: CardNote(deckID: deck.id, flashcardID: firstCard.id, plainTextContent: "  Trimmed note  "),
                    images: [ImageAsset(deckID: deck.id, flashcardID: firstCard.id, canonicalFilename: "a.png")]
                ),
                StudyCardSnapshot(
                    card: secondCard,
                    note: nil,
                    images: []
                ),
            ]
        )
    }
}
