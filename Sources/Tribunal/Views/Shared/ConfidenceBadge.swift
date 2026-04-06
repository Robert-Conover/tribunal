import SwiftUI

struct ConfidenceBadge: View {
    let level: ConfidenceLevel

    var body: some View {
        HStack(spacing: 4) {
            Text("Confidence:")
                .foregroundStyle(TribunalTheme.textSecondary)
            Text(level.displayName)
                .foregroundStyle(TribunalTheme.textPrimary)
        }
        .font(.system(size: 12, weight: .medium))
    }
}
