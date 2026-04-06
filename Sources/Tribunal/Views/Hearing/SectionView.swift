import SwiftUI

struct SectionView: View {
    let section: HearingSection
    let content: String
    let isActive: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Rectangle()
                .fill(TribunalTheme.sectionMarkerColor(for: section))
                .frame(width: 3)

            VStack(alignment: .leading, spacing: 8) {
                Text(section.displayName.uppercased())
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1)
                    .foregroundStyle(TribunalTheme.sectionMarkerColor(for: section))

                if section == .evidenceGaps {
                    EvidenceGapsContent(content: content)
                } else {
                    Text(content)
                        .font(.system(size: 14))
                        .foregroundStyle(TribunalTheme.textPrimary)
                        .textSelection(.enabled)
                        .lineSpacing(4)
                }

                if isActive {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(TribunalTheme.accent)
                            .frame(width: 6, height: 6)
                            .opacity(0.8)
                        Text("Analyzing...")
                            .font(.system(size: 12).italic())
                            .foregroundStyle(TribunalTheme.textSecondary)
                    }
                    .padding(.top, 4)
                }
            }
            .padding(.leading, 16)
            .padding(.vertical, 12)
        }
        .padding(.horizontal, 20)
    }
}

private struct EvidenceGapsContent: View {
    let content: String

    var body: some View {
        Text(content)
            .font(.system(size: 14))
            .foregroundStyle(TribunalTheme.textPrimary)
            .textSelection(.enabled)
            .lineSpacing(4)
    }
}

struct EvidenceGapCard: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Rectangle()
                .fill(TribunalTheme.evidenceGapsMarker)
                .frame(width: 2)

            Text(text)
                .font(.system(size: 13))
                .foregroundStyle(TribunalTheme.textPrimary)
                .lineSpacing(3)
        }
        .padding(12)
        .background(TribunalTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
