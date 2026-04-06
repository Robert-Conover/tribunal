import Foundation

enum VerdictJudgment: String, Codable, CaseIterable {
    case supported
    case mostlyTrue = "mostly_true"
    case mixed
    case insufficientEvidence = "insufficient_evidence"
    case unsupported
    case disproven

    var displayName: String {
        switch self {
        case .supported: "Supported"
        case .mostlyTrue: "Mostly True"
        case .mixed: "Mixed"
        case .insufficientEvidence: "Insufficient Evidence"
        case .unsupported: "Unsupported"
        case .disproven: "Disproven"
        }
    }
}

enum ConfidenceLevel: String, Codable, CaseIterable {
    case high, moderate, low, insufficient

    var displayName: String { rawValue.capitalized }
}

enum HearingSection: String, CaseIterable {
    case claimSummary = "claim_summary"
    case prosecution
    case defense
    case evidenceGaps = "evidence_gaps"
    case rhetoricalAnalysis = "rhetorical_analysis"
    case whatWouldChange = "what_would_change"
    case verdict

    var displayName: String {
        switch self {
        case .claimSummary: "Claim Summary"
        case .prosecution: "Prosecution"
        case .defense: "Defense"
        case .evidenceGaps: "Evidence Gaps"
        case .rhetoricalAnalysis: "Rhetorical Analysis"
        case .whatWouldChange: "What Would Change the Verdict"
        case .verdict: "Verdict"
        }
    }
}
