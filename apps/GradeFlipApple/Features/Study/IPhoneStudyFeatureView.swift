import SwiftUI

struct IPhoneStudyFeatureView: View {
    @Binding var decks: [StudyDeckDraft]
    @Binding var selectedDeckID: UUID?
    @Binding var selectedCardID: UUID?
    @Binding var selectedTheme: GradeFlipTheme

    @State private var showsBack = false
    @State private var showsNotesSheet = false
    @State private var showsImageStrip = false

    private var selectedDeck: StudyDeckDraft? {
        if let selectedDeckID {
            return decks.first(where: { $0.id == selectedDeckID })
        }
        return decks.first
    }

    private var selectedCardIndex: Int {
        guard let selectedDeck else { return 0 }
        guard let selectedCardID,
              let index = selectedDeck.cards.firstIndex(where: { $0.id == selectedCardID }) else {
            return 0
        }
        return index
    }

    private var selectedCard: StudyCardDraft? {
        guard let selectedDeck, selectedDeck.cards.indices.contains(selectedCardIndex) else {
            return nil
        }
        return selectedDeck.cards[selectedCardIndex]
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    deckPicker
                    progressHeader
                    if let selectedCard {
                        StudyFlipCardView(
                            frontText: selectedCard.frontText,
                            backText: selectedCard.backText,
                            showsBack: $showsBack,
                            theme: selectedTheme
                        )
                        quickActions(for: selectedCard)
                        imageStrip(for: selectedCard)
                        notesSummary(for: selectedCard)
                    } else {
                        ContentUnavailableView("No Cards", systemImage: "rectangle.stack")
                    }
                    editEntryPoint
                }
                .padding(20)
            }
            .background(selectedTheme.surfaceBackground.ignoresSafeArea())
            .navigationTitle("Study")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showsNotesSheet) {
                if let selectedCard {
                    NavigationStack {
                        ScrollView {
                            Text(selectedCard.noteText.isEmpty ? "No note saved for this card yet." : selectedCard.noteText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        }
                        .navigationTitle("Card Note")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                    .presentationDetents([.medium, .large])
                }
            }
        }
        .onAppear {
            seedSelection()
        }
        .onChange(of: selectedDeckID) { _, _ in
            showsBack = false
            seedSelection()
        }
    }

    private var deckPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Deck")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(decks) { deck in
                        Button {
                            selectedDeckID = deck.id
                            selectedCardID = deck.cards.first?.id
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(deck.title)
                                    .font(.headline)
                                Text("\(deck.cards.count) cards")
                                    .font(.caption)
                            }
                            .foregroundStyle(deck.id == selectedDeck?.id ? .white : .primary)
                            .padding(16)
                            .frame(width: 200, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .fill(deck.id == selectedDeck?.id ? selectedTheme.accent : Color(.secondarySystemBackground))
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var progressHeader: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(selectedDeck?.title ?? "Choose a deck")
                    .font(.title3.weight(.semibold))
                if let selectedDeck {
                    Text("\(selectedCardIndex + 1) of \(max(selectedDeck.cards.count, 1))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Button {
                toggleStar()
            } label: {
                Image(systemName: selectedCard?.isStarred == true ? "star.fill" : "star")
                    .font(.title3)
                    .foregroundStyle(selectedTheme.accent)
            }
            .accessibilityLabel("Toggle card star")
        }
    }

    @ViewBuilder
    private func quickActions(for card: StudyCardDraft) -> some View {
        HStack(spacing: 12) {
            Button {
                moveCard(-1)
            } label: {
                Label("Back", systemImage: "chevron.left")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(StudyActionButtonStyle(fill: .secondary))
            .disabled(selectedCardIndex == 0)

            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    showsBack.toggle()
                }
            } label: {
                Label(showsBack ? "Front" : "Flip", systemImage: "arrow.triangle.2.circlepath")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(StudyActionButtonStyle(fill: .accent(selectedTheme.accent)))

            Button {
                moveCard(1)
            } label: {
                Label("Next", systemImage: "chevron.right")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(StudyActionButtonStyle(fill: .secondary))
            .disabled(!(selectedDeck?.cards.indices.contains(selectedCardIndex + 1) ?? false))
        }

        HStack(spacing: 12) {
            Button {
                showsNotesSheet = true
            } label: {
                Label("Notes", systemImage: "note.text")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(StudyActionButtonStyle(fill: .secondary))

            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showsImageStrip.toggle()
                }
            } label: {
                Label(card.images.isEmpty ? "Images" : "Images \(card.images.count)", systemImage: "photo.on.rectangle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(StudyActionButtonStyle(fill: .secondary))
        }
    }

    @ViewBuilder
    private func imageStrip(for card: StudyCardDraft) -> some View {
        if showsImageStrip, !card.images.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(card.images) { image in
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(color(for: image.tintName).gradient)
                            .frame(width: 132, height: 104)
                            .overlay(
                                VStack(alignment: .leading, spacing: 8) {
                                    Image(systemName: "photo")
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                    Text(image.filename)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.white)
                                        .lineLimit(2)
                                }
                                .padding(14)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            )
                    }
                }
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    private func notesSummary(for card: StudyCardDraft) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Quick Note")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(card.noteText.isEmpty ? "Keep the study surface clean. Longer note editing stays on the dedicated note screen." : card.noteText)
                .font(.subheadline)
                .lineLimit(3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                )
        }
    }

    private var editEntryPoint: some View {
        NavigationLink {
            DeckManagementFeatureView()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Edit Decks")
                        .font(.headline)
                    Text("Card creation and deep edits stay on a separate surface so study flow stays compact.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "slider.horizontal.3")
                    .font(.title3)
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(Color(.tertiarySystemBackground))
            )
        }
        .buttonStyle(.plain)
    }

    private func moveCard(_ offset: Int) {
        guard let selectedDeck else { return }
        let newIndex = min(max(selectedCardIndex + offset, 0), selectedDeck.cards.count - 1)
        selectedCardID = selectedDeck.cards[newIndex].id
        showsBack = false
    }

    private func seedSelection() {
        if selectedDeckID == nil {
            selectedDeckID = decks.first?.id
        }
        if let selectedDeck, selectedCardID == nil || !selectedDeck.cards.contains(where: { $0.id == selectedCardID }) {
            selectedCardID = selectedDeck.cards.first?.id
        }
    }

    private func toggleStar() {
        guard let deckID = selectedDeck?.id,
              let deckIndex = decks.firstIndex(where: { $0.id == deckID }),
              let selectedCardID,
              let cardIndex = decks[deckIndex].cards.firstIndex(where: { $0.id == selectedCardID }) else {
            return
        }
        decks[deckIndex].cards[cardIndex].isStarred.toggle()
    }

    private func color(for tintName: String) -> Color {
        switch tintName {
        case "green": return .green
        case "orange": return .orange
        case "pink": return .pink
        default: return selectedTheme.accent
        }
    }
}

private struct StudyActionButtonStyle: ButtonStyle {
    enum Fill {
        case secondary
        case accent(Color)
    }

    let fill: Fill

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .padding(.vertical, 14)
            .padding(.horizontal, 12)
            .background(background(isPressed: configuration.isPressed))
            .foregroundStyle(foreground)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }

    private var foreground: Color {
        switch fill {
        case .secondary: return .primary
        case .accent: return .white
        }
    }

    @ViewBuilder
    private func background(isPressed: Bool) -> some View {
        switch fill {
        case .secondary:
            Color(.secondarySystemBackground)
                .opacity(isPressed ? 0.7 : 1)
        case let .accent(color):
            color.opacity(isPressed ? 0.82 : 1)
        }
    }
}
