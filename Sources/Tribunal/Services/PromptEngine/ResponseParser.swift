import Foundation

struct ResponseParser {
    enum ParseError: Error {
        case invalidJSON
    }

    static func parse(_ json: String) throws -> HearingResponse {
        guard let data = json.data(using: .utf8) else {
            throw ParseError.invalidJSON
        }
        do {
            return try JSONDecoder().decode(HearingResponse.self, from: data)
        } catch {
            throw ParseError.invalidJSON
        }
    }

    static func applyToCase(_ response: HearingResponse, case hearingCase: Case) {
        hearingCase.claimSummary = response.claimSummary
        hearingCase.prosecution = response.prosecution
        hearingCase.defense = response.defense
        hearingCase.evidenceGaps = response.evidenceGaps
        hearingCase.rhetoricalAnalysis = response.rhetoricalAnalysis
        hearingCase.whatWouldChange = response.whatWouldChange
        hearingCase.verdictJudgment = VerdictJudgment(rawValue: response.verdict.judgment)
        hearingCase.verdictConfidence = ConfidenceLevel(rawValue: response.verdict.confidence)
        hearingCase.verdictSummary = response.verdict.summary
        hearingCase.verdictUnknowns = response.verdict.unknowns
        hearingCase.status = .completed
    }
}
