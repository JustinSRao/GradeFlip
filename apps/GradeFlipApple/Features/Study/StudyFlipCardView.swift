import SwiftUI

struct StudyFlipCardView: View {
    let frontText: String
    let backText: String
    @Binding var showsBack: Bool
    let theme: GradeFlipTheme

    var body: some View {
        ZStack {
            cardFace(text: frontText, label: "Front", isVisible: !showsBack)
                .rotation3DEffect(.degrees(showsBack ? -180 : 0), axis: (x: 0, y: 1, z: 0))

            cardFace(text: backText, label: "Back", isVisible: showsBack)
                .rotation3DEffect(.degrees(showsBack ? 0 : 180), axis: (x: 0, y: 1, z: 0))
        }
        .frame(height: 320)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.82)) {
                showsBack.toggle()
            }
        }
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(showsBack ? "Flashcard back" : "Flashcard front")
        .accessibilityHint("Double tap to flip the card.")
    }

    private func cardFace(text: String, label: String, isVisible: Bool) -> some View {
        RoundedRectangle(cornerRadius: 34, style: .continuous)
            .fill(theme.accent.gradient)
            .overlay(
                RoundedRectangle(cornerRadius: 34, style: .continuous)
                    .strokeBorder(.white.opacity(0.22), lineWidth: 1)
            )
            .overlay {
                VStack(alignment: .leading, spacing: 20) {
                    Text(label)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white.opacity(0.78))
                    Spacer()
                    Text(text)
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.78)
                    Spacer()
                    Label("Tap to flip", systemImage: "hand.tap")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.84))
                }
                .padding(28)
                .opacity(isVisible ? 1 : 0)
            }
            .shadow(color: theme.accent.opacity(0.24), radius: 28, y: 18)
    }
}
