import XCTest
import SwiftData
@testable import Tribunal

final class ResponseParserTests: XCTestCase {
    let validJSON = """
    {
        "claim_summary": "The claim states that 5G causes cancer.",
        "prosecution": "No scientific evidence supports this. The WHO and FDA have found no link.",
        "defense": "Some early studies suggest further research is needed on RF exposure.",
        "evidence_gaps": ["No long-term epidemiological study on 5G specifically", "Limited independent replication"],
        "rhetorical_analysis": "The claim uses appeal to fear and lacks specific citations.",
        "what_would_change": "A large-scale epidemiological study showing elevated cancer rates in 5G-dense areas.",
        "verdict": {
            "judgment": "unsupported",
            "confidence": "high",
            "summary": "The available evidence does not support the claim that 5G causes cancer.",
            "unknowns": ["Long-term effects of mmWave exposure"]
        }
    }
    """

    func testParseValidJSON() throws {
        let response = try ResponseParser.parse(validJSON)
        XCTAssertEqual(response.claimSummary, "The claim states that 5G causes cancer.")
        XCTAssertEqual(response.verdict.judgment, "unsupported")
        XCTAssertEqual(response.verdict.confidence, "high")
        XCTAssertEqual(response.evidenceGaps.count, 2)
        XCTAssertEqual(response.verdict.unknowns.count, 1)
    }

    func testParseInvalidJSON() {
        XCTAssertThrowsError(try ResponseParser.parse("not json")) { error in
            XCTAssertTrue(error is ResponseParser.ParseError)
        }
    }

    func testApplyToCase() throws {
        let response = try ResponseParser.parse(validJSON)
        let c = Case(caseNumber: "2026-0406-001", rawContent: "test", inputType: .text, modelUsed: "gpt-5.4-mini")
        ResponseParser.applyToCase(response, case: c)

        XCTAssertEqual(c.claimSummary, "The claim states that 5G causes cancer.")
        XCTAssertEqual(c.prosecution, "No scientific evidence supports this. The WHO and FDA have found no link.")
        XCTAssertEqual(c.defense, "Some early studies suggest further research is needed on RF exposure.")
        XCTAssertEqual(c.evidenceGaps.count, 2)
        XCTAssertEqual(c.rhetoricalAnalysis, "The claim uses appeal to fear and lacks specific citations.")
        XCTAssertEqual(c.verdictJudgment, .unsupported)
        XCTAssertEqual(c.verdictConfidence, .high)
        XCTAssertEqual(c.status, .completed)
    }

    func testApplyToCaseWithUnknownJudgment() throws {
        let json = validJSON.replacingOccurrences(of: "\"unsupported\"", with: "\"unknown_value\"")
        let response = try ResponseParser.parse(json)
        let c = Case(caseNumber: "2026-0406-001", rawContent: "test", inputType: .text, modelUsed: "gpt-5.4-mini")
        ResponseParser.applyToCase(response, case: c)
        XCTAssertNil(c.verdictJudgment)
    }
}
