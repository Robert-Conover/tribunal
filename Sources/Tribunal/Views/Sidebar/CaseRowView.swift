import SwiftUI

struct CaseRowView: View {
    let hearingCase: Case

    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(hearingCase.claimSummary.isEmpty ? hearingCase.rawContent : hearingCase.claimSummary)
                    .font(.system(size: 13))
                    .foregroundStyle(TribunalTheme.textPrimary)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(hearingCase.createdAt, style: .date)
                    .font(.system(size: 11))
                    .foregroundStyle(TribunalTheme.textSecondary)
            }

            Spacer()

            if let judgment = hearingCase.verdictJudgment {
                VerdictBadge(judgment: judgment)
            } else if hearingCase.status == .inProgress {
                ProgressView()
                    .scaleEffect(0.5)
                    .frame(width: 16, height: 16)
            }
        }
        .padding(.vertical, 4)
    }
}
