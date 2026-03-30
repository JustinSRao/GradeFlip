import Foundation

public enum OnlineBackendKind: String, Codable, Sendable {
    case supabasePostgres
    case customPostgres
}

public struct OnlineBackendSelection: Codable, Equatable, Sendable {
    public var kind: OnlineBackendKind
    public var projectURL: URL
    public var databaseSchema: String
    public var storageBucket: String
    public var usesRowLevelSecurity: Bool

    public init(
        kind: OnlineBackendKind,
        projectURL: URL,
        databaseSchema: String,
        storageBucket: String,
        usesRowLevelSecurity: Bool
    ) {
        self.kind = kind
        self.projectURL = projectURL
        self.databaseSchema = databaseSchema
        self.storageBucket = storageBucket
        self.usesRowLevelSecurity = usesRowLevelSecurity
    }

    public static let recommendedSupabase = OnlineBackendSelection(
        kind: .supabasePostgres,
        projectURL: URL(string: "https://gradeflip.example.supabase.co")!,
        databaseSchema: "public",
        storageBucket: "gradeflip-user-assets",
        usesRowLevelSecurity: true
    )
}
