import SwiftUI

struct GradeFlipRootView: View {
    private let appEnvironment = GradeFlipAppEnvironment.bootstrap(
        rootURL: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        ?? FileManager.default.temporaryDirectory
    )

    var body: some View {
        NavigationStack {
            List {
                Section("Foundation") {
                    Text("App shell scaffolded in Sprint 1")
                    Text("Storage, billing, sync, and AI flows will attach here as their sprints land")
                }

                Section("Sprint 2 Storage") {
                    Text("Root: \(appEnvironment.storageConfiguration.rootURL.path)")
                    Text("Protection: \(appEnvironment.storageConfiguration.protection.rawValue)")
                    Text("SwiftData index preferred: \(appEnvironment.storageConfiguration.prefersSwiftDataIndex ? "yes" : "no")")
                }

                Section("Sprint 3 Billing") {
                    Text("App mode: \(appEnvironment.previewEntitlements.appMode().rawValue)")
                    Text("Core product: \(appEnvironment.billingCatalog.paidCoreUnlock.id)")
                    Text("Subscription: \(appEnvironment.billingCatalog.onlineSubscriptionMonthly.id)")
                    Text("Token packs: \(appEnvironment.billingCatalog.aiTokenPacks.map(\.displayName).joined(separator: ", "))")
                }

                Section("Sprint 4 CRUD") {
                    NavigationLink("Open Deck Management Preview") {
                        DeckManagementFeatureView()
                    }
                    Text("Delete actions stay behind explicit confirmation")
                    Text("Deck titles are editable without changing stable card ownership")
                }

                Section("Sprint 5 Notes") {
                    Text("Per-card notes stay deck-scoped and card-linked")
                    Text("Lined-paper editing and dictation scaffold are now reachable from card flows")
                }
            }
            .navigationTitle("GradeFlip")
        }
    }
}
