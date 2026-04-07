import Foundation
import SwiftData
import Combine

@MainActor
final class HearingViewModel: ObservableObject {
    enum FailureKind: Equatable {
        case missingAPIKey
        case invalidAPIKey
        case network
        case api
        case unknown
    }

    @Published var sectionContent: [HearingSection: String] = [:]
    @Published var activeSection: HearingSection?
    @Published var isStreaming = false
    @Published var error: String?
    @Published var failureKind: FailureKind?
    @Published var currentCase: Case?

    private let llmProvider: any LLMProvider
    private var accumulatedJSON = ""

    init(llmProvider: any LLMProvider) {
        self.llmProvider = llmProvider
    }

    func startHearing(claim: String, model: String, modelContext: ModelContext) async {
        let caseNumber = CaseNumberGenerator.generate()
        let inputType: InputType = (claim.hasPrefix("http://") || claim.hasPrefix("https://")) ? .url : .text
        let newCase = Case(caseNumber: caseNumber, rawContent: claim, inputType: inputType, modelUsed: model)
        if inputType == .url { newCase.sourceURL = claim }

        modelContext.insert(newCase)
        currentCase = newCase
        isStreaming = true
        error = nil
        failureKind = nil
        accumulatedJSON = ""
        sectionContent = [:]
        activeSection = nil

        do {
            for try await event in llmProvider.streamHearing(claim: claim, model: model) {
                switch event {
                case .delta(let content):
                    accumulatedJSON += content
                    updateSections()
                case .usage(let prompt, let completion):
                    newCase.promptTokens = prompt
                    newCase.completionTokens = completion
                case .done:
                    break
                }
            }

            newCase.rawResponse = accumulatedJSON
            let response = try ResponseParser.parse(accumulatedJSON)
            ResponseParser.applyToCase(response, case: newCase)
        } catch {
            newCase.rawResponse = accumulatedJSON
            newCase.status = .failed
            self.currentCase = newCase
            self.error = error.localizedDescription
            self.failureKind = classify(error)
        }

        isStreaming = false
    }

    func retryHearing(from hearingCase: Case, modelContext: ModelContext) async {
        await startHearing(
            claim: hearingCase.rawContent,
            model: hearingCase.modelUsed,
            modelContext: modelContext
        )
    }

    func reset() {
        currentCase = nil
        sectionContent = [:]
        activeSection = nil
        error = nil
        failureKind = nil
        accumulatedJSON = ""
    }

    private func classify(_ error: Error) -> FailureKind {
        switch error {
        case OpenAIError.noAPIKey:
            return .missingAPIKey
        case OpenAIError.invalidAPIKey:
            return .invalidAPIKey
        case OpenAIError.networkError:
            return .network
        case OpenAIError.httpError, OpenAIError.streamingError:
            return .api
        default:
            return .unknown
        }
    }

    private func updateSections() {
        let extracted = SectionExtractor.extract(from: accumulatedJSON)
        for item in extracted {
            sectionContent[item.section] = item.content
        }
        activeSection = extracted.last?.section
    }
}
