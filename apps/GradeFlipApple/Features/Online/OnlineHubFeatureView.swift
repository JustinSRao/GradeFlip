import SwiftUI

struct OnlineHubFeatureView: View {
    let entitlements: EntitlementSnapshot
    let backendSelection: String

    @State private var signedIn = true
    @State private var syncEnabled = true
    @State private var socialFeed: [String] = [
        "Avery shared Biology Sprint Review",
        "Jordan requested your US History deck",
        "Mika kept a 3-day buddy streak alive",
    ]

    var body: some View {
        NavigationStack {
            List {
                Section("Account") {
                    Label(signedIn ? "Signed In" : "Signed Out", systemImage: signedIn ? "person.crop.circle.badge.checkmark" : "person.crop.circle.badge.xmark")
                    Text("Backend: \(backendSelection)")
                    Toggle("Enable Cloud Sync", isOn: $syncEnabled)
                        .disabled(!signedIn)
                }

                Section("Subscription") {
                    Text("App mode: \(entitlements.appMode().rawValue)")
                    Text(entitlements.hasOnlineSubscription ? "Online subscription active" : "Offline core remains available without a subscription.")
                }

                Section("Sync") {
                    Text(syncEnabled ? "Deck metadata sync is ready to reconcile local JSON with the relational backend." : "Offline-only mode stays available without login.")
                    Text("Conflict policy: merge near-simultaneous edits, otherwise prefer the newer side.")
                        .foregroundStyle(.secondary)
                }

                Section("Social Feed") {
                    ForEach(socialFeed, id: \.self) { item in
                        Text(item)
                    }
                }
            }
            .navigationTitle("Online")
        }
    }
}
