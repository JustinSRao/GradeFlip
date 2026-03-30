import SwiftUI

struct GradeFlipRootView: View {
    private let appEnvironment = GradeFlipAppEnvironment.bootstrap(
        rootURL: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        ?? FileManager.default.temporaryDirectory
    )
    @State private var studyDecks: [StudyDeckDraft] = []
    @State private var selectedDeckID: UUID?
    @State private var selectedCardID: UUID?
    @State private var selectedTheme: GradeFlipTheme = .blue
    @State private var useDarkAppearancePreview = false

    var body: some View {
        TabView {
            studySurface
                .tabItem {
                    Label("Study", systemImage: "rectangle.on.rectangle")
                }

            OnlineHubFeatureView(
                entitlements: appEnvironment.previewEntitlements,
                backendSelection: appEnvironment.backendSelection.kind.rawValue
            )
            .tabItem {
                Label("Online", systemImage: "person.2")
            }

            AIHubFeatureView(
                tokenBalance: appEnvironment.previewEntitlements.availableStudyTokens,
                providerOptions: appEnvironment.aiProviderCatalog.models.map(\.displayName),
                deckOptions: appEnvironment.previewStudyDecks.map(\.title)
            )
            .tabItem {
                Label("AI", systemImage: "sparkles.rectangle.stack")
            }
        }
        .task {
            if studyDecks.isEmpty {
                studyDecks = appEnvironment.previewStudyDecks
                selectedTheme = appEnvironment.defaultTheme
                selectedDeckID = studyDecks.first?.id
                selectedCardID = studyDecks.first?.cards.first?.id
            }
        }
    }

    @ViewBuilder
    private var studySurface: some View {
        #if os(iOS)
        ViewThatFits {
            IPadStudyWorkspaceView(
                decks: $studyDecks,
                selectedDeckID: $selectedDeckID,
                selectedCardID: $selectedCardID,
                selectedTheme: $selectedTheme
            )
            IPhoneStudyFeatureView(
                decks: $studyDecks,
                selectedDeckID: $selectedDeckID,
                selectedCardID: $selectedCardID,
                selectedTheme: $selectedTheme
            )
        }
        #elseif os(macOS)
        NavigationStack {
            MacStudyExperienceView(
                decks: $studyDecks,
                selectedDeckID: $selectedDeckID,
                selectedCardID: $selectedCardID,
                selectedTheme: $selectedTheme,
                useDarkAppearancePreview: $useDarkAppearancePreview
            )
        }
        #else
        NavigationStack {
            IPhoneStudyFeatureView(
                decks: $studyDecks,
                selectedDeckID: $selectedDeckID,
                selectedCardID: $selectedCardID,
                selectedTheme: $selectedTheme
            )
        }
        #endif
    }
}
