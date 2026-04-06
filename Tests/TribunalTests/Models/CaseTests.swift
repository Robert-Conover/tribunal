import XCTest
import SwiftData
@testable import Tribunal

final class CaseTests: XCTestCase {
    private func makeContext() throws -> ModelContext {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Case.self, configurations: config)
        return ModelContext(container)
    }

    func testCaseCreation() throws {
        let c = Case(caseNumber: "2026-0406-001", rawContent: "5G causes cancer", inputType: .text, modelUsed: "gpt-5.4-mini")
        XCTAssertEqual(c.caseNumber, "2026-0406-001")
        XCTAssertEqual(c.rawContent, "5G causes cancer")
        XCTAssertEqual(c.status, .inProgress)
        XCTAssertEqual(c.inputType, .text)
        XCTAssertEqual(c.modelUsed, "gpt-5.4-mini")
        XCTAssertTrue(c.claimSummary.isEmpty)
        XCTAssertTrue(c.prosecution.isEmpty)
        XCTAssertNil(c.verdictJudgment)
    }

    func testCasePersistence() throws {
        let context = try makeContext()
        let c = Case(caseNumber: "2026-0406-001", rawContent: "test claim", inputType: .text, modelUsed: "gpt-5.4-mini")
        context.insert(c)
        try context.save()

        let descriptor = FetchDescriptor<Case>()
        let results = try context.fetch(descriptor)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.rawContent, "test claim")
    }

    func testCaseStatusTransition() throws {
        let c = Case(caseNumber: "2026-0406-001", rawContent: "test", inputType: .text, modelUsed: "gpt-5.4-mini")
        XCTAssertEqual(c.status, .inProgress)
        c.status = .completed
        XCTAssertEqual(c.status, .completed)
    }

    func testCaseVerdictProperties() throws {
        let c = Case(caseNumber: "2026-0406-001", rawContent: "test", inputType: .text, modelUsed: "gpt-5.4-mini")
        XCTAssertNil(c.verdictJudgment)
        XCTAssertNil(c.verdictConfidence)

        c.verdictJudgment = .unsupported
        c.verdictConfidence = .high
        XCTAssertEqual(c.verdictJudgment, .unsupported)
        XCTAssertEqual(c.verdictConfidence, .high)
    }

    func testCaseURLInput() throws {
        let c = Case(caseNumber: "2026-0406-002", rawContent: "https://example.com/article", inputType: .url, modelUsed: "gpt-5.4-mini")
        c.sourceURL = "https://example.com/article"
        XCTAssertEqual(c.inputType, .url)
        XCTAssertEqual(c.sourceURL, "https://example.com/article")
    }
}
