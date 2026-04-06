import Foundation

enum StreamEvent {
    case delta(String)
    case usage(promptTokens: Int, completionTokens: Int)
    case done
}

struct HearingResponse: Codable {
    let claimSummary: String
    let prosecution: String
    let defense: String
    let evidenceGaps: [String]
    let rhetoricalAnalysis: String
    let whatWouldChange: String
    let verdict: VerdictResponse

    enum CodingKeys: String, CodingKey {
        case claimSummary = "claim_summary"
        case prosecution, defense
        case evidenceGaps = "evidence_gaps"
        case rhetoricalAnalysis = "rhetorical_analysis"
        case whatWouldChange = "what_would_change"
        case verdict
    }

    struct VerdictResponse: Codable {
        let judgment: String
        let confidence: String
        let summary: String
        let unknowns: [String]
    }
}

struct OpenAIStreamChunk: Codable {
    let choices: [Choice]
    let usage: Usage?

    struct Choice: Codable {
        let delta: Delta
        let finishReason: String?

        enum CodingKeys: String, CodingKey {
            case delta
            case finishReason = "finish_reason"
        }
    }

    struct Delta: Codable {
        let content: String?
    }

    struct Usage: Codable {
        let promptTokens: Int
        let completionTokens: Int

        enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case completionTokens = "completion_tokens"
        }
    }
}

protocol LLMProvider {
    func streamHearing(claim: String, model: String) -> AsyncThrowingStream<StreamEvent, Error>
}
