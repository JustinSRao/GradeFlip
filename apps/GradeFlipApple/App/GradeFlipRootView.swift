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

                Section("Platforms") {
                    Text("iPhone")
                    Text("iPad")
                    Text("Mac")
                }
            }
            .navigationTitle("GradeFlip")
        }
    }
}
