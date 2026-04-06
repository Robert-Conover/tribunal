import SwiftUI

struct VerdictBadge: View {
    let judgment: VerdictJudgment

    var body: some View {
        Text(judgment.displayName.uppercased())
            .font(.system(size: 11, weight: .bold, design: .serif))
            .tracking(0.8)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(TribunalTheme.verdictColor(for: judgment).opacity(0.15))
            .foregroundStyle(TribunalTheme.verdictColor(for: judgment))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
