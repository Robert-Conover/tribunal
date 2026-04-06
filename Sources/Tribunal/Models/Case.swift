import Foundation
import SwiftData

@Model
final class Case {
    @Attribute(.unique) var id: UUID
    var caseNumber: String
    var createdAt: Date
    var statusRaw: String
    var inputTypeRaw: String
    var rawContent: String
    var sourceURL: String?
    var claimSummary: String
    var prosecution: String
    var defense: String
    var evidenceGaps: [String]
    var rhetoricalAnalysis: String
    var whatWouldChange: String
    var verdictJudgmentRaw: String?
    var verdictConfidenceRaw: String?
    var verdictSummary: String
    var verdictUnknowns: [String]
    var modelUsed: String
    var promptTokens: Int
    var completionTokens: Int
    var rawResponse: String?

    var status: CaseStatus {
        get { CaseStatus(rawValue: statusRaw) ?? .inProgress }
        set { statusRaw = newValue.rawValue }
    }

    var inputType: InputType {
        get { InputType(rawValue: inputTypeRaw) ?? .text }
        set { inputTypeRaw = newValue.rawValue }
    }

    var verdictJudgment: VerdictJudgment? {
        get { verdictJudgmentRaw.flatMap { VerdictJudgment(rawValue: $0) } }
        set { verdictJudgmentRaw = newValue?.rawValue }
    }

    var verdictConfidence: ConfidenceLevel? {
        get { verdictConfidenceRaw.flatMap { ConfidenceLevel(rawValue: $0) } }
        set { verdictConfidenceRaw = newValue?.rawValue }
    }

    init(caseNumber: String, rawContent: String, inputType: InputType, modelUsed: String) {
        self.id = UUID()
        self.caseNumber = caseNumber
        self.createdAt = Date()
        self.statusRaw = CaseStatus.inProgress.rawValue
        self.inputTypeRaw = inputType.rawValue
        self.rawContent = rawContent
        self.sourceURL = nil
        self.claimSummary = ""
        self.prosecution = ""
        self.defense = ""
        self.evidenceGaps = []
        self.rhetoricalAnalysis = ""
        self.whatWouldChange = ""
        self.verdictJudgmentRaw = nil
        self.verdictConfidenceRaw = nil
        self.verdictSummary = ""
        self.verdictUnknowns = []
        self.modelUsed = modelUsed
        self.promptTokens = 0
        self.completionTokens = 0
        self.rawResponse = nil
    }
}
