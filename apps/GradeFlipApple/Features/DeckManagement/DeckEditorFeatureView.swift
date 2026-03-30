import SwiftUI

struct DeckEditorFeatureView: View {
    @Binding var deck: DeckDraft
    @Binding var pendingCardDeletion: CardDraft?
    @State private var newFrontText = ""
    @State private var newBackText = ""

    var body: some View {
        List {
            Section("Deck") {
                TextField("Deck title", text: $deck.title)
                Text("\(deck.cards.count) cards")
                    .foregroundStyle(.secondary)
            }

            Section("Add Card") {
                TextField("Front", text: $newFrontText)
                TextField("Back", text: $newBackText)
                Button("Add Card") {
                    guard !newFrontText.isEmpty || !newBackText.isEmpty else { return }
                    deck.cards.append(CardDraft(frontText: newFrontText, backText: newBackText))
                    newFrontText = ""
                    newBackText = ""
                }
            }

            Section("Cards") {
                ForEach($deck.cards) { $card in
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Front text", text: $card.frontText)
                        TextField("Back text", text: $card.backText)
                        NavigationLink("Open Notes") {
                            DeckNotesFeatureView(card: $card)
                        }
                        Text(card.noteText.isEmpty ? "No note yet" : "Note ready")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        NavigationLink("Manage Images") {
                            CardImagesFeatureView(card: $card)
                        }
                        Text(card.images.isEmpty ? "No images attached" : "\(card.images.count) image attachments")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Button("Delete Card", role: .destructive) {
                            pendingCardDeletion = card
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle(deck.title)
    }
}
