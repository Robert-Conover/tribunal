import SwiftUI

struct VerdictCardView: View {
    let hearingCase: Case

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
                .padding(.horizontal, 20)

            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text("VERDICT")
                        .font(.system(size: 11, weight: .bold))
                        .tracking(1)
                        .foregroundStyle(TribunalTheme.accent)

                    if let judgment = hearingCase.verdictJudgment {
                        VerdictBadge(judgment: judgment)
                    }

                    Spacer()

                    if let confidence = hearingCase.verdictConfidence {
                        ConfidenceBadge(level: confidence)
                    }
                }

                if !hearingCase.verdictSummary.isEmpty {
                    Text(hearingCase.verdictSummary)
                        .font(.system(size: 14))
                        .foregroundStyle(TribunalTheme.textPrimary)
                        .lineSpacing(4)
                        .textSelection(.enabled)
                }

                if !hearingCase.verdictUnknowns.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Unresolved Questions")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(TribunalTheme.textSecondary)

                        ForEach(hearingCase.verdictUnknowns, id: \.self) { unknown in
                            HStack(alignment: .top, spacing: 6) {
                                Text("•")
                                    .foregroundStyle(TribunalTheme.textSecondary)
                                Text(unknown)
                                    .font(.system(size: 13))
                                    .foregroundStyle(TribunalTheme.textPrimary)
                            }
                        }
                    }
                }

                if !hearingCase.whatWouldChange.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 0) {
                            Rectangle()
                                .fill(TribunalTheme.defenseMarker)
                                .frame(width: 3)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("WHAT WOULD CHANGE THE VERDICT")
                                    .font(.system(size: 10, weight: .bold))
                                    .tracking(0.8)
                                    .foregroundStyle(TribunalTheme.defenseMarker)
                                Text(hearingCase.whatWouldChange)
                                    .font(.system(size: 13))
                                    .foregroundStyle(TribunalTheme.textPrimary)
                                    .lineSpacing(3)
                                    .textSelection(.enabled)
                            }
                            .padding(.leading, 12)
                            .padding(.vertical, 10)
                        }
                        .padding(10)
                        .tribunalGlassCard()
                    }
                }

                HStack(spacing: 16) {
                    CopyButton(label: "Copy Analysis", text: formatFullAnalysis())
                    CopyButton(label: "Copy Verdict", text: formatVerdictSummary())
                    ShareSheetButton(item: formatFullAnalysis()) {
                        HStack(spacing: 4) {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                        }
                        .font(.system(size: 12))
                    }
                }
                .padding(.top, 8)
                .tribunalGlassGroup(spacing: 16)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }

    private func formatFullAnalysis() -> String {
        var parts: [String] = []
        parts.append("# Case \(hearingCase.caseNumber)")
        parts.append("**Claim:** \(hearingCase.rawContent)\n")
        if !hearingCase.claimSummary.isEmpty {
            parts.append("## Claim Summary\n\(hearingCase.claimSummary)\n")
        }
        if !hearingCase.prosecution.isEmpty {
            parts.append("## Prosecution\n\(hearingCase.prosecution)\n")
        }
        if !hearingCase.defense.isEmpty {
            parts.append("## Defense\n\(hearingCase.defense)\n")
        }
        if !hearingCase.evidenceGaps.isEmpty {
            parts.append("## Evidence Gaps\n" + hearingCase.evidenceGaps.map { "- \($0)" }.joined(separator: "\n") + "\n")
        }
        if !hearingCase.rhetoricalAnalysis.isEmpty {
            parts.append("## Rhetorical Analysis\n\(hearingCase.rhetoricalAnalysis)\n")
        }
        if !hearingCase.whatWouldChange.isEmpty {
            parts.append("## What Would Change the Verdict\n\(hearingCase.whatWouldChange)\n")
        }
        if let j = hearingCase.verdictJudgment, let c = hearingCase.verdictConfidence {
            parts.append("## Verdict: \(j.displayName) (Confidence: \(c.displayName))\n\(hearingCase.verdictSummary)")
        }
        return parts.joined(separator: "\n")
    }

    private func formatVerdictSummary() -> String {
        guard let j = hearingCase.verdictJudgment, let c = hearingCase.verdictConfidence else {
            return hearingCase.verdictSummary
        }
        return "Verdict: \(j.displayName) (Confidence: \(c.displayName))\n\n\(hearingCase.verdictSummary)"
    }
}

struct CopyButton: View {
    let label: String
    let text: String
    @State private var copied = false

    var body: some View {
        Button {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(text, forType: .string)
            copied = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { copied = false }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: copied ? "checkmark" : "doc.on.doc")
                Text(copied ? "Copied" : label)
            }
            .font(.system(size: 12, weight: .medium))
        }
        .tribunalSecondaryButtonStyle()
        .tint(copied ? TribunalTheme.verdictSupported : TribunalTheme.accent)
    }
}
