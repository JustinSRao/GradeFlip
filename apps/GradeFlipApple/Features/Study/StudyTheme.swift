import SwiftUI

enum GradeFlipTheme: String, CaseIterable, Identifiable {
    case pink
    case red
    case orange
    case yellow
    case lime
    case green
    case cyan
    case babyBlue
    case blue
    case navyBlue
    case purple
    case magenta
    case lightPink

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .babyBlue: return "Baby Blue"
        case .navyBlue: return "Navy Blue"
        case .lightPink: return "Light Pink"
        default: return rawValue.capitalized
        }
    }

    var accent: Color {
        switch self {
        case .pink: return Color(red: 0.92, green: 0.33, blue: 0.58)
        case .red: return Color(red: 0.82, green: 0.19, blue: 0.18)
        case .orange: return Color(red: 0.93, green: 0.46, blue: 0.17)
        case .yellow: return Color(red: 0.86, green: 0.70, blue: 0.16)
        case .lime: return Color(red: 0.62, green: 0.79, blue: 0.20)
        case .green: return Color(red: 0.17, green: 0.59, blue: 0.34)
        case .cyan: return Color(red: 0.08, green: 0.61, blue: 0.66)
        case .babyBlue: return Color(red: 0.49, green: 0.73, blue: 0.96)
        case .blue: return Color(red: 0.17, green: 0.37, blue: 0.86)
        case .navyBlue: return Color(red: 0.10, green: 0.16, blue: 0.44)
        case .purple: return Color(red: 0.47, green: 0.24, blue: 0.72)
        case .magenta: return Color(red: 0.76, green: 0.20, blue: 0.54)
        case .lightPink: return Color(red: 0.96, green: 0.67, blue: 0.80)
        }
    }

    var secondaryAccent: Color {
        accent.opacity(0.28)
    }

    var surfaceBackground: LinearGradient {
        LinearGradient(
            colors: [
                accent.opacity(0.16),
                secondaryAccent.opacity(0.52),
                Color(.systemBackground),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
