import Foundation
import SwiftData
import Combine

@MainActor
final class HearingViewModel: ObservableObject {
    @Published var sectionContent: [HearingSection: String] = [:]
    @Published var activeSection: HearingSection?
    @Published var isStreaming = false
    @Published var error: String?
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
            modelContext.delete(newCase)
            self.currentCase = nil
            self.error = error.localizedDescription
        }

        isStreaming = false
    }

    func reset() {
        currentCase = nil
        sectionContent = [:]
        activeSection = nil
        error = nil
        accumulatedJSON = ""
    }

    private func updateSections() {
        let extracted = SectionExtractor.extract(from: accumulatedJSON)
        for item in extracted {
            sectionContent[item.section] = item.content
        }
        activeSection = extracted.last?.section
    }
}
