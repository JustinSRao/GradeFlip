import Foundation
import GradeFlipBilling
import GradeFlipStorage

struct GradeFlipAppEnvironment {
    let storageConfiguration: LocalDeckStorageConfiguration
    let billingCatalog: GradeFlipProductCatalog
    let previewEntitlements: EntitlementSnapshot

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
            )
        )
    }
}
