import XCTest
import SwiftData
@testable import Tribunal

@MainActor
final class HearingViewModelTests: XCTestCase {
    private func makeContext() throws -> ModelContext {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Case.self, configurations: config)
        return ModelContext(container)
    }

    private let sampleJSON = """
    {"claim_summary":"Summary","prosecution":"Against","defense":"For","evidence_gaps":["Gap 1"],"rhetorical_analysis":"Analysis","what_would_change":"Change","verdict":{"judgment":"unsupported","confidence":"high","summary":"Verdict text","unknowns":["Unknown 1"]}}
    """

    func testStartHearingCreatesCase() async throws {
        let mock = MockLLMProvider()
        mock.events = [.delta(sampleJSON), .done]
        let vm = HearingViewModel(llmProvider: mock)
        let context = try makeContext()

        await vm.startHearing(claim: "test claim", model: "gpt-5.4-mini", modelContext: context)

        XCTAssertNotNil(vm.currentCase)
        XCTAssertEqual(vm.currentCase?.rawContent, "test claim")
        XCTAssertFalse(vm.isStreaming)
    }

    func testStartHearingPopulatesCase() async throws {
        let mock = MockLLMProvider()
        mock.events = [.delta(sampleJSON), .usage(promptTokens: 50, completionTokens: 200), .done]
        let vm = HearingViewModel(llmProvider: mock)
        let context = try makeContext()

        await vm.startHearing(claim: "test claim", model: "gpt-5.4-mini", modelContext: context)

        let c = vm.currentCase!
        XCTAssertEqual(c.status, .completed)
        XCTAssertEqual(c.claimSummary, "Summary")
        XCTAssertEqual(c.verdictJudgment, .unsupported)
        XCTAssertEqual(c.verdictConfidence, .high)
        XCTAssertEqual(c.promptTokens, 50)
        XCTAssertEqual(c.completionTokens, 200)
    }

    func testStartHearingHandlesError() async throws {
        let mock = MockLLMProvider()
        mock.error = OpenAIError.noAPIKey
        let vm = HearingViewModel(llmProvider: mock)
        let context = try makeContext()

        await vm.startHearing(claim: "test", model: "gpt-5.4-mini", modelContext: context)

        XCTAssertNotNil(vm.error)
        XCTAssertEqual(vm.currentCase?.status, .failed)
        XCTAssertFalse(vm.isStreaming)
    }

    func testStartHearingDetectsURLInput() async throws {
        let mock = MockLLMProvider()
        mock.events = [.delta(sampleJSON), .done]
        let vm = HearingViewModel(llmProvider: mock)
        let context = try makeContext()

        await vm.startHearing(claim: "https://example.com/article", model: "gpt-5.4-mini", modelContext: context)

        XCTAssertEqual(vm.currentCase?.inputType, .url)
    }

    func testStartHearingPassesModel() async throws {
        let mock = MockLLMProvider()
        mock.events = [.delta(sampleJSON), .done]
        let vm = HearingViewModel(llmProvider: mock)
        let context = try makeContext()

        await vm.startHearing(claim: "test", model: "gpt-5.4", modelContext: context)

        XCTAssertEqual(mock.receivedModel, "gpt-5.4")
        XCTAssertEqual(vm.currentCase?.modelUsed, "gpt-5.4")
    }

    func testSectionExtractionDuringStreaming() async throws {
        let mock = MockLLMProvider()
        mock.events = [
            .delta("{\"claim_summary\": \"Test summary\", \"prosecution\": \"Against"),
            .delta(" the claim\", "),
            .delta("\"defense\": \"For the claim\", \"evidence_gaps\": [\"Gap\"], "),
            .delta("\"rhetorical_analysis\": \"Analysis\", \"what_would_change\": \"Change\", "),
            .delta("\"verdict\": {\"judgment\": \"mixed\", \"confidence\": \"moderate\", \"summary\": \"Mixed verdict\", \"unknowns\": []}}"),
            .done
        ]
        let vm = HearingViewModel(llmProvider: mock)
        let context = try makeContext()

        await vm.startHearing(claim: "test", model: "gpt-5.4-mini", modelContext: context)

        XCTAssertFalse(vm.sectionContent.isEmpty)
        XCTAssertEqual(vm.currentCase?.status, .completed)
    }
}
