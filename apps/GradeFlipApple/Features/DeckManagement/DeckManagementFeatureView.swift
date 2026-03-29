import SwiftUI

struct DeckManagementFeatureView: View {
    @State private var decks: [DeckDraft] = DeckDraft.sampleDecks
    @State private var selectedDeckID: UUID?
    @State private var pendingDeckDeletion: DeckDraft?
    @State private var pendingCardDeletion: CardDraft?

    private var selectedDeck: DeckDraft? {
        decks.first(where: { $0.id == selectedDeckID }) ?? decks.first
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
                    .contextMenu {
                        Button("Delete Deck", role: .destructive) {
                            pendingDeckDeletion = deck
                        }
                    }
                }
            }
            .navigationTitle("Decks")
        } detail: {
            if let deck = selectedDeck {
                DeckEditorFeatureView(
                    deck: binding(for: deck.id),
                    pendingCardDeletion: $pendingCardDeletion
                )
            } else {
                ContentUnavailableView("No Decks", systemImage: "rectangle.stack")
            }
        }
        .confirmationDialog(
            "Delete deck?",
            isPresented: Binding(
                get: { pendingDeckDeletion != nil },
                set: { if !$0 { pendingDeckDeletion = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let pendingDeckDeletion {
                    decks.removeAll { $0.id == pendingDeckDeletion.id }
                    if selectedDeckID == pendingDeckDeletion.id {
                        selectedDeckID = decks.first?.id
                    }
                }
                self.pendingDeckDeletion = nil
            }
        } message: {
            Text("This removes the deck and its cards from local storage.")
        }
        .confirmationDialog(
            "Delete card?",
            isPresented: Binding(
                get: { pendingCardDeletion != nil },
                set: { if !$0 { pendingCardDeletion = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                guard let pendingCardDeletion else { return }
                for deckIndex in decks.indices {
                    decks[deckIndex].cards.removeAll { $0.id == pendingCardDeletion.id }
                }
                self.pendingCardDeletion = nil
            }
        } message: {
            Text("Delete confirmation is required before the card is removed.")
        }
    }

    private func binding(for deckID: UUID) -> Binding<DeckDraft> {
        Binding {
            decks.first(where: { $0.id == deckID }) ?? DeckDraft(title: "Missing", cards: [])
        } set: { updatedDeck in
            if let index = decks.firstIndex(where: { $0.id == deckID }) {
                decks[index] = updatedDeck
            }
        }
    }
}
