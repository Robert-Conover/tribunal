import XCTest
@testable import Tribunal

final class VerdictTests: XCTestCase {
    func testVerdictJudgmentDisplayNames() {
        XCTAssertEqual(VerdictJudgment.supported.displayName, "Supported")
        XCTAssertEqual(VerdictJudgment.mostlyTrue.displayName, "Mostly True")
        XCTAssertEqual(VerdictJudgment.mixed.displayName, "Mixed")
        XCTAssertEqual(VerdictJudgment.insufficientEvidence.displayName, "Insufficient Evidence")
        XCTAssertEqual(VerdictJudgment.unsupported.displayName, "Unsupported")
        XCTAssertEqual(VerdictJudgment.disproven.displayName, "Disproven")
    }

    func testVerdictJudgmentCodable() throws {
        let encoded = try JSONEncoder().encode(VerdictJudgment.mostlyTrue)
        let decoded = try JSONDecoder().decode(VerdictJudgment.self, from: encoded)
        XCTAssertEqual(decoded, .mostlyTrue)
    }

    func testVerdictJudgmentFromRawValue() {
        XCTAssertEqual(VerdictJudgment(rawValue: "mostly_true"), .mostlyTrue)
        XCTAssertEqual(VerdictJudgment(rawValue: "insufficient_evidence"), .insufficientEvidence)
        XCTAssertNil(VerdictJudgment(rawValue: "bogus"))
    }

    func testConfidenceLevelDisplayNames() {
        XCTAssertEqual(ConfidenceLevel.high.displayName, "High")
        XCTAssertEqual(ConfidenceLevel.moderate.displayName, "Moderate")
        XCTAssertEqual(ConfidenceLevel.low.displayName, "Low")
        XCTAssertEqual(ConfidenceLevel.insufficient.displayName, "Insufficient")
    }

    func testHearingSectionOrder() {
        let sections = HearingSection.allCases
        XCTAssertEqual(sections.count, 7)
        XCTAssertEqual(sections.first, .claimSummary)
        XCTAssertEqual(sections.last, .verdict)
    }

    func testHearingSectionRawValues() {
        XCTAssertEqual(HearingSection.claimSummary.rawValue, "claim_summary")
        XCTAssertEqual(HearingSection.evidenceGaps.rawValue, "evidence_gaps")
        XCTAssertEqual(HearingSection.rhetoricalAnalysis.rawValue, "rhetorical_analysis")
        XCTAssertEqual(HearingSection.whatWouldChange.rawValue, "what_would_change")
    }

    func testCaseStatusRawValues() {
        XCTAssertEqual(CaseStatus.inProgress.rawValue, "in_progress")
        XCTAssertEqual(CaseStatus.completed.rawValue, "completed")
        XCTAssertEqual(CaseStatus.failed.rawValue, "failed")
    }

    func testInputTypeDetection() {
        XCTAssertEqual(InputType.text.rawValue, "text")
        XCTAssertEqual(InputType.url.rawValue, "url")
    }
}
