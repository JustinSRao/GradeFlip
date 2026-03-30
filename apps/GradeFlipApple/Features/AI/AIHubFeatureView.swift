import SwiftUI

struct AIHubFeatureView: View {
    let tokenBalance: Int
    let providerOptions: [String]
    let deckOptions: [String]

    @State private var selectedProvider = "GPT-5.4 Mini"
    @State private var mode = "Deck Grounded"
    @State private var selectedDecks: Set<String> = []
    @State private var estimatedTokens = 12
    @State private var prompt = "Quiz me on osmosis and cell respiration."

    var body: some View {
        NavigationStack {
            List {
                Section("Provider") {
                    Picker("Model", selection: $selectedProvider) {
                        ForEach(providerOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    Picker("Mode", selection: $mode) {
                        Text("Deck Grounded").tag("Deck Grounded")
                        Text("Web Enabled").tag("Web Enabled")
                    }
                    Text("Provider switching keeps the same chat contract and estimation flow.")
                        .foregroundStyle(.secondary)
                }

                Section("Deck Context") {
                    ForEach(deckOptions, id: \.self) { deck in
                        Toggle(deck, isOn: Binding(
                            get: { selectedDecks.contains(deck) },
                            set: { isSelected in
                                if isSelected {
                                    selectedDecks.insert(deck)
                                } else {
                                    selectedDecks.remove(deck)
                                }
                            }
                        ))
                    }
                    Text(selectedDecks.isEmpty ? "No decks selected." : "\(selectedDecks.count) decks selected for grounding.")
                        .foregroundStyle(.secondary)
                }

                Section("Prompt") {
                    TextEditor(text: $prompt)
                        .frame(minHeight: 120)
                    Text("Estimated cost: about \(estimatedTokens) study tokens")
                        .font(.headline)
                    Text("Token estimation is arithmetic from pricing tables and token counts, not another model call.")
                        .foregroundStyle(.secondary)
                    Text("Balance: \(tokenBalance) study tokens")
                }

                Section("Response Surface") {
                    Text(mode == "Deck Grounded" ? "Deck-grounded responses stay constrained to selected GradeFlip content." : "Web-enabled mode can use the metered web workflow once credentials are attached.")
                    Text("Selected provider: \(selectedProvider)")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("AI")
        }
        .onAppear {
            if selectedDecks.isEmpty, let firstDeck = deckOptions.first {
                selectedDecks = [firstDeck]
            }
        }
    }
}
