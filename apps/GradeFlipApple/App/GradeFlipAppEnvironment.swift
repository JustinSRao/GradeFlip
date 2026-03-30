import Foundation
import GradeFlipAI
import GradeFlipBilling
import GradeFlipOnline
import GradeFlipStorage

struct GradeFlipAppEnvironment {
    let storageConfiguration: LocalDeckStorageConfiguration
    let billingCatalog: GradeFlipProductCatalog
    let previewEntitlements: EntitlementSnapshot
    let previewStudyDecks: [StudyDeckDraft]
    let defaultTheme: GradeFlipTheme
    let backendSelection: OnlineBackendSelection
    let aiProviderCatalog: AIProviderCatalog

    static func bootstrap(rootURL: URL) -> GradeFlipAppEnvironment {
        GradeFlipAppEnvironment(
            storageConfiguration: LocalDeckStorageConfiguration(
                rootURL: rootURL,
                protection: .completeUntilFirstUserAuthentication,
                prefersSwiftDataIndex: true
            ),
            billingCatalog: .placeholder,
            previewEntitlements: EntitlementSnapshot(
                hasPaidCoreAccess: true,
                hasOnlineSubscription: false,
                availableStudyTokens: 0,
                accountState: .signedIn
            ),
            previewStudyDecks: StudyDeckDraft.sampleDecks,
            defaultTheme: .blue,
            backendSelection: .recommendedSupabase,
            aiProviderCatalog: .default
        )
    }
}
