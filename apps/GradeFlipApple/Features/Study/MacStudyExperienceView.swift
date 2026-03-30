import SwiftUI

struct MacStudyExperienceView: View {
    @Binding var decks: [StudyDeckDraft]
    @Binding var selectedDeckID: UUID?
    @Binding var selectedCardID: UUID?
    @Binding var selectedTheme: GradeFlipTheme
    @Binding var useDarkAppearancePreview: Bool
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
        HSplitView {
            List(selection: $selectedDeckID) {
                Section("Decks") {
                    ForEach(decks) { deck in
                        Text(deck.title)
                            .tag(deck.id)
                    }
                }
            }
            .frame(minWidth: 180, idealWidth: 220)

            VStack(spacing: 0) {
                headerBar
                Divider()
                if let selectedDeck, let selectedCard {
                    HSplitView {
                        VStack(spacing: 20) {
                            StudyFlipCardView(
                                frontText: selectedCard.frontText,
                                backText: selectedCard.backText,
                                showsBack: $showsBack,
                                theme: selectedTheme
                            )
                            HStack {
                                Button("Previous Card") { move(-1) }
                                    .keyboardShortcut(.leftArrow, modifiers: [])
                                Button(showsBack ? "Show Front" : "Flip Card") {
                                    withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                                        showsBack.toggle()
                                    }
                                }
                                .keyboardShortcut(.space, modifiers: [])
                                .tint(selectedTheme.accent)
                                Button("Next Card") { move(1) }
                                    .keyboardShortcut(.rightArrow, modifiers: [])
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        }
                        .padding(24)

                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                macPanel(title: "Deck", value: selectedDeck.title)
                                macPanel(title: "Note", value: selectedCard.noteText.isEmpty ? "No note yet." : selectedCard.noteText)
                                macPanel(title: "Images", value: selectedCard.images.isEmpty ? "No image attachments." : selectedCard.images.map(\.filename).joined(separator: "\n"))
                                macPanel(title: "Accessibility", value: "Keyboard shortcuts are wired for previous, next, and flip. Theme contrast remains semantic instead of hardcoded per view.")
                            }
                            .padding(24)
                        }
                        .frame(minWidth: 280, idealWidth: 320)
                    }
                    .background(selectedTheme.surfaceBackground)
                } else {
                    ContentUnavailableView("Choose a Deck", systemImage: "rectangle.grid.1x2")
                }
            }
        }
        .preferredColorScheme(useDarkAppearancePreview ? .dark : .light)
        .onAppear {
            if selectedDeckID == nil {
                selectedDeckID = decks.first?.id
            }
            if selectedCardID == nil {
                selectedCardID = selectedDeck?.cards.first?.id
            }
        }
    }

    private var headerBar: some View {
        HStack(spacing: 16) {
            Picker("Theme", selection: $selectedTheme) {
                ForEach(GradeFlipTheme.allCases) { theme in
                    Text(theme.displayName).tag(theme)
                }
            }
            .pickerStyle(.menu)

            Toggle("Dark Preview", isOn: $useDarkAppearancePreview)
                .toggleStyle(.switch)

            Spacer()

            NavigationLink("Deck Editor") {
                DeckManagementFeatureView()
            }
        }
        .padding(18)
    }

    private func macPanel(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            Text(value)
                .font(.body)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
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
