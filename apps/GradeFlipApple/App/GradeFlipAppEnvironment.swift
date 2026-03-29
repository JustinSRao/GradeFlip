import Foundation
import GradeFlipStorage

struct GradeFlipAppEnvironment {
    let storageConfiguration: LocalDeckStorageConfiguration

    static func bootstrap(rootURL: URL) -> GradeFlipAppEnvironment {
        GradeFlipAppEnvironment(
            storageConfiguration: LocalDeckStorageConfiguration(
                rootURL: rootURL,
                protection: .completeUntilFirstUserAuthentication,
                prefersSwiftDataIndex: true
            )
        )
    }
}
