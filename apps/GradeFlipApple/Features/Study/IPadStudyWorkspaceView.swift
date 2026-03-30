import SwiftUI

struct IPadStudyWorkspaceView: View {
    @Binding var decks: [StudyDeckDraft]
    @Binding var selectedDeckID: UUID?
    @Binding var selectedCardID: UUID?
    @Binding var selectedTheme: GradeFlipTheme
    @State private var showsBack = false

    private var selectedDeck: StudyDeckDraft? {
        if let selectedDeckID {
            return decks.first(where: { $0.id == selectedDeckID })
        }
        return decks.first
    }

    private var selectedCard: StudyCardDraft? {
        guard let selectedDeck else { return nil }
        if let selectedCardID,
           let match = selectedDeck.cards.first(where: { $0.id == selectedCardID }) {
            return match
        }
        return selectedDeck.cards.first
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedDeckID) {
                ForEach(decks) { deck in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(deck.title)
                            .font(.headline)
                        Text("\(deck.cards.count) cards")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .tag(deck.id)
                }
            }
            .navigationTitle("Decks")
        } content: {
            List(selection: $selectedCardID) {
                if let selectedDeck {
                    ForEach(selectedDeck.cards) { card in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(card.frontText)
                                .font(.headline)
                                .lineLimit(2)
                            Text(card.noteText.isEmpty ? "No note yet" : card.noteText)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        .tag(card.id)
                    }
                }
            }
            .navigationTitle("Cards")
        } detail: {
            if let selectedCard {
                HStack(spacing: 24) {
                    VStack(spacing: 18) {
                        StudyFlipCardView(
                            frontText: selectedCard.frontText,
                            backText: selectedCard.backText,
                            showsBack: $showsBack,
                            theme: selectedTheme
                        )
                        HStack {
                            Button("Previous") {
                                move(-1)
                            }
                            .buttonStyle(.bordered)
                            Button(showsBack ? "Show Front" : "Flip") {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.84)) {
                                    showsBack.toggle()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(selectedTheme.accent)
                            Button("Next") {
                                move(1)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .frame(maxWidth: .infinity)

                    VStack(alignment: .leading, spacing: 16) {
                        workspacePanel(
                            title: "Note",
                            systemImage: "note.text",
                            body: selectedCard.noteText.isEmpty ? "Open the dedicated editor for longer notes." : selectedCard.noteText
                        )
                        workspacePanel(
                            title: "Images",
                            systemImage: "photo.on.rectangle.angled",
                            body: selectedCard.images.isEmpty ? "No image attachments on this card." : selectedCard.images.map(\.filename).joined(separator: "\n")
                        )
                        workspacePanel(
                            title: "Workspace",
                            systemImage: "cursorarrow.motionlines",
                            body: "iPad keeps decks, cards, and supporting details visible together so the study loop does not collapse to a single pane."
                        )
                    }
                    .frame(width: 280)
                }
                .padding(24)
                .background(selectedTheme.surfaceBackground.ignoresSafeArea())
            } else {
                ContentUnavailableView("Choose a Card", systemImage: "rectangle.stack")
            }
        }
        .onAppear {
            if selectedDeckID == nil {
                selectedDeckID = decks.first?.id
            }
            if selectedCardID == nil {
                selectedCardID = selectedDeck?.cards.first?.id
            }
        }
    }

    private func workspacePanel(title: String, systemImage: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: systemImage)
                .font(.headline)
            Text(body)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private func move(_ offset: Int) {
        guard let selectedDeck,
              let selectedCardID,
              let currentIndex = selectedDeck.cards.firstIndex(where: { $0.id == selectedCardID }) else {
            return
        }
        let newIndex = min(max(currentIndex + offset, 0), selectedDeck.cards.count - 1)
        self.selectedCardID = selectedDeck.cards[newIndex].id
        showsBack = false
    }
}
