import XCTest
@testable import Tribunal

final class HearingPromptTests: XCTestCase {
    func testBuildReturnsSystemAndUserMessages() {
        let result = HearingPrompt.build(claim: "5G causes cancer")
        XCTAssertFalse(result.system.isEmpty)
        XCTAssertTrue(result.user.contains("5G causes cancer"))
    }

    func testSystemPromptContainsRequiredSections() {
        let result = HearingPrompt.build(claim: "test")
        let system = result.system
        XCTAssertTrue(system.contains("claim_summary"), "Missing claim_summary instruction")
        XCTAssertTrue(system.contains("prosecution"), "Missing prosecution instruction")
        XCTAssertTrue(system.contains("defense"), "Missing defense instruction")
        XCTAssertTrue(system.contains("evidence_gaps"), "Missing evidence_gaps instruction")
        XCTAssertTrue(system.contains("rhetorical_analysis"), "Missing rhetorical_analysis instruction")
        XCTAssertTrue(system.contains("what_would_change"), "Missing what_would_change instruction")
        XCTAssertTrue(system.contains("verdict"), "Missing verdict instruction")
    }

    func testSystemPromptContainsVerdictJudgmentValues() {
        let result = HearingPrompt.build(claim: "test")
        let system = result.system
        XCTAssertTrue(system.contains("supported"))
        XCTAssertTrue(system.contains("mostly_true"))
        XCTAssertTrue(system.contains("mixed"))
        XCTAssertTrue(system.contains("insufficient_evidence"))
        XCTAssertTrue(system.contains("unsupported"))
        XCTAssertTrue(system.contains("disproven"))
    }

    func testSystemPromptContainsConfidenceLevels() {
        let result = HearingPrompt.build(claim: "test")
        let system = result.system
        XCTAssertTrue(system.contains("\"high\""))
        XCTAssertTrue(system.contains("\"moderate\""))
        XCTAssertTrue(system.contains("\"low\""))
        XCTAssertTrue(system.contains("\"insufficient\""))
    }

    func testSystemPromptInstructsJSON() {
        let result = HearingPrompt.build(claim: "test")
        XCTAssertTrue(result.system.contains("JSON"))
    }

    func testSystemPromptInstructsAdversarialBalance() {
        let result = HearingPrompt.build(claim: "test")
        let system = result.system
        XCTAssertTrue(system.contains("genuinely") || system.contains("genuine"))
        XCTAssertTrue(system.contains("straw-man") || system.contains("straw man"))
    }
}
