import SwiftUI

struct CardImagesFeatureView: View {
    @Binding var card: CardDraft
    @State private var pendingDeletion: ImageDraft?
    @State private var selectedImage: ImageDraft?

    var body: some View {
        List {
            Section("Import") {
                Button("Import Sample Image") {
                    let count = card.images.count + 1
                    card.images.append(
                        ImageDraft(
                            filename: "flashcard-image-\(count).png",
                            tintName: ["blue", "green", "orange", "pink"][count % 4]
                        )
                    )
                }
                Text("Sprint 6 scaffolds image import with generated filenames and preview behavior.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Images") {
                if card.images.isEmpty {
                    Text("No images attached yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(card.images) { image in
                        HStack {
                            Image(systemName: "photo")
                                .foregroundStyle(color(for: image.tintName))
                            VStack(alignment: .leading) {
                                Text(image.filename)
                                Text("Tap preview to enlarge")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button("Preview") {
                                selectedImage = image
                            }
                            .buttonStyle(.bordered)
                            Button("Delete", role: .destructive) {
                                pendingDeletion = image
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Card Images")
        .confirmationDialog(
            "Remove image?",
            isPresented: Binding(
                get: { pendingDeletion != nil },
                set: { if !$0 { pendingDeletion = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button("Remove", role: .destructive) {
                if let pendingDeletion {
                    card.images.removeAll { $0.id == pendingDeletion.id }
                }
                self.pendingDeletion = nil
            }
        } message: {
            Text("Image removal requires confirmation before the attachment is deleted.")
        }
        .sheet(item: $selectedImage) { image in
            VStack(spacing: 20) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(color(for: image.tintName).gradient)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 72))
                            .foregroundStyle(.white)
                    )
                    .frame(width: 260, height: 220)
                Text(image.filename)
                    .font(.headline)
                Button("Close") {
                    selectedImage = nil
                }
            }
            .padding(24)
        }
    }

    private func color(for tintName: String) -> Color {
        switch tintName {
        case "green": return .green
        case "orange": return .orange
        case "pink": return .pink
        default: return .blue
        }
    }
}
