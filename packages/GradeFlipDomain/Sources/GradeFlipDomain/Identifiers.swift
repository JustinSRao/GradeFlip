import Foundation

public protocol GradeFlipIdentifier: RawRepresentable, Hashable, Sendable where RawValue == String {
    init()
}

public extension GradeFlipIdentifier {
    init() {
        self.init(rawValue: UUID().uuidString.lowercased())!
    }
}

public struct DeckID: GradeFlipIdentifier {
    public let rawValue: String

    public init?(rawValue: String) {
        guard !rawValue.isEmpty else { return nil }
        self.rawValue = rawValue
    }
}

public struct FlashcardID: GradeFlipIdentifier {
    public let rawValue: String

    public init?(rawValue: String) {
        guard !rawValue.isEmpty else { return nil }
        self.rawValue = rawValue
    }
}

public struct NoteID: GradeFlipIdentifier {
    public let rawValue: String

    public init?(rawValue: String) {
        guard !rawValue.isEmpty else { return nil }
        self.rawValue = rawValue
    }
}

public struct ImageAssetID: GradeFlipIdentifier {
    public let rawValue: String

    public init?(rawValue: String) {
        guard !rawValue.isEmpty else { return nil }
        self.rawValue = rawValue
    }
}

public struct UserID: GradeFlipIdentifier {
    public let rawValue: String

    public init?(rawValue: String) {
        guard !rawValue.isEmpty else { return nil }
        self.rawValue = rawValue
    }
}
