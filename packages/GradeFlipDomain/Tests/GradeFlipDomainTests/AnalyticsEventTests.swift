import XCTest
@testable import GradeFlipDomain

final class AnalyticsEventTests: XCTestCase {
    func testAnalyticsEventNamesRemainStableAndSerializable() throws {
        let event = AnalyticsEvent(
            name: .aiPromptSent,
            metadata: ["mode": "deck_grounded", "provider": "openai"]
        )

        let data = try JSONEncoder().encode(event)
        let decoded = try JSONDecoder().decode(AnalyticsEvent.self, from: data)

        XCTAssertEqual(decoded.name, .aiPromptSent)
        XCTAssertEqual(decoded.metadata["mode"], "deck_grounded")
        XCTAssertEqual(AnalyticsEventName.allCases.count, 12)
    }
}
