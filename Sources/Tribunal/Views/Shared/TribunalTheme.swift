import SwiftUI

enum TribunalTheme {
    static let background = Color(red: 0.094, green: 0.094, blue: 0.106)       // #18181b
    static let surface = Color(red: 0.067, green: 0.067, blue: 0.078)          // #111114
    static let textPrimary = Color(red: 0.961, green: 0.961, blue: 0.961)      // #f5f5f5
    static let textSecondary = Color(red: 0.961, green: 0.961, blue: 0.961).opacity(0.4)
    static let accent = Color(red: 0.831, green: 0.647, blue: 0.455)           // #d4a574

    static let verdictSupported = Color(red: 0.133, green: 0.773, blue: 0.369) // #22c55e
    static let verdictMixed = Color(red: 0.961, green: 0.620, blue: 0.043)     // #f59e0b
    static let verdictUnsupported = Color(red: 0.937, green: 0.267, blue: 0.267) // #ef4444

    static let prosecutionMarker = Color(red: 0.937, green: 0.267, blue: 0.267) // #ef4444
    static let defenseMarker = Color(red: 0.231, green: 0.510, blue: 0.965)    // #3b82f6
    static let evidenceGapsMarker = Color(red: 0.961, green: 0.620, blue: 0.043) // #f59e0b

    static func verdictColor(for judgment: VerdictJudgment?) -> Color {
        switch judgment {
        case .supported, .mostlyTrue: verdictSupported
        case .mixed, .insufficientEvidence: verdictMixed
        case .unsupported, .disproven: verdictUnsupported
        case nil: textSecondary
        }
    }

    static func sectionMarkerColor(for section: HearingSection) -> Color {
        switch section {
        case .prosecution: prosecutionMarker
        case .defense: defenseMarker
        case .evidenceGaps: evidenceGapsMarker
        case .whatWouldChange: defenseMarker
        case .verdict: accent
        default: textSecondary
        }
    }
}
