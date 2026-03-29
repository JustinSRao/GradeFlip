import SwiftUI

struct DeckNotesFeatureView: View {
    @Binding var card: CardDraft
    @State private var isDictationAvailable = true
    @State private var dictationStatus = "Idle"

    var body: some View {
        VStack(spacing: 0) {
            LinedPaperNoteEditor(text: $card.noteText)

            Divider()

            HStack {
                Label("Dictation", systemImage: "mic")
                Spacer()
                Text(dictationStatus)
                    .foregroundStyle(.secondary)
                Button(isDictationAvailable ? "Insert Sample Speech" : "Unavailable") {
                    guard isDictationAvailable else {
                        dictationStatus = "Unavailable"
                        return
                    }
                    let separator = card.noteText.isEmpty ? "" : "\n"
                    card.noteText += "\(separator)Dictated note placeholder."
                    dictationStatus = "Inserted"
                }
                .buttonStyle(.bordered)
                .disabled(!isDictationAvailable)
            }
            .padding()
        }
        .navigationTitle("Card Notes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LinedPaperNoteEditor: View {
    @Binding var text: String

    var body: some View {
        ZStack {
            LinedPaperBackground()
            TextEditor(text: $text)
                .scrollContentBackground(.hidden)
                .padding(16)
                .font(.system(.body, design: .serif))
        }
    }
}

struct LinedPaperBackground: View {
    var body: some View {
        GeometryReader { geometry in
            let rowHeight: CGFloat = 28
            let rowCount = max(Int(geometry.size.height / rowHeight), 1)

            ZStack(alignment: .topLeading) {
                Color(red: 0.99, green: 0.98, blue: 0.92)
                Rectangle()
                    .fill(Color.red.opacity(0.15))
                    .frame(width: 2)
                    .padding(.leading, 28)

                VStack(spacing: 0) {
                    ForEach(0..<rowCount, id: \.self) { _ in
                        Spacer()
                            .frame(height: rowHeight - 1)
                        Rectangle()
                            .fill(Color.blue.opacity(0.18))
                            .frame(height: 1)
                    }
                }
            }
        }
    }
}
