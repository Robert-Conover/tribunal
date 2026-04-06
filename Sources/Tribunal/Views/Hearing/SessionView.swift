import SwiftUI

struct SessionView: View {
    let hearingCase: Case
    @ObservedObject var viewModel: HearingViewModel

    private var isLiveSession: Bool {
        viewModel.currentCase?.id == hearingCase.id
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    caseHeader
                        .padding(.bottom, 24)

                    if isLiveSession && viewModel.isStreaming {
                        streamingSections
                    } else if hearingCase.status == .completed {
                        completedSections
                    } else if hearingCase.status == .failed {
                        errorSection
                    }
                }
                .padding(.vertical, 24)
                .id("session-bottom")
            }
            .background(TribunalTheme.background)
            .onChange(of: viewModel.activeSection) {
                withAnimation(.easeOut(duration: 0.3)) {
                    proxy.scrollTo("session-bottom", anchor: .bottom)
                }
            }
        }
    }

    private var caseHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Case \(hearingCase.caseNumber)")
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(TribunalTheme.textSecondary)

            Text(hearingCase.rawContent)
                .font(.system(size: 18, weight: .medium, design: .serif))
                .foregroundStyle(TribunalTheme.textPrimary)
                .lineSpacing(4)
                .textSelection(.enabled)

            HStack(spacing: 12) {
                Text(hearingCase.createdAt, format: .dateTime.month().day().year().hour().minute())
                    .font(.system(size: 12))
                    .foregroundStyle(TribunalTheme.textSecondary)

                if hearingCase.promptTokens > 0 {
                    Text("\(hearingCase.promptTokens + hearingCase.completionTokens) tokens")
                        .font(.system(size: 12))
                        .foregroundStyle(TribunalTheme.textSecondary)
                }
            }
        }
        .padding(.horizontal, 24)
    }

    private var streamingSections: some View {
        ForEach(HearingSection.allCases, id: \.self) { section in
            if let content = viewModel.sectionContent[section], !content.isEmpty {
                SectionView(
                    section: section,
                    content: content,
                    isActive: viewModel.activeSection == section && viewModel.isStreaming
                )
                .padding(.bottom, 16)
            }
        }
    }

    private var completedSections: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !hearingCase.claimSummary.isEmpty {
                SectionView(section: .claimSummary, content: hearingCase.claimSummary, isActive: false)
            }
            if !hearingCase.prosecution.isEmpty {
                SectionView(section: .prosecution, content: hearingCase.prosecution, isActive: false)
            }
            if !hearingCase.defense.isEmpty {
                SectionView(section: .defense, content: hearingCase.defense, isActive: false)
            }
            if !hearingCase.evidenceGaps.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top, spacing: 0) {
                        Rectangle()
                            .fill(TribunalTheme.evidenceGapsMarker)
                            .frame(width: 3)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("EVIDENCE GAPS")
                                .font(.system(size: 11, weight: .bold))
                                .tracking(1)
                                .foregroundStyle(TribunalTheme.evidenceGapsMarker)

                            ForEach(hearingCase.evidenceGaps, id: \.self) { gap in
                                EvidenceGapCard(text: gap)
                            }
                        }
                        .padding(.leading, 16)
                        .padding(.vertical, 12)
                    }
                    .padding(.horizontal, 20)
                }
            }
            if !hearingCase.rhetoricalAnalysis.isEmpty {
                SectionView(section: .rhetoricalAnalysis, content: hearingCase.rhetoricalAnalysis, isActive: false)
            }
            if !hearingCase.whatWouldChange.isEmpty {
                SectionView(section: .whatWouldChange, content: hearingCase.whatWouldChange, isActive: false)
            }
            if hearingCase.verdictJudgment != nil {
                VerdictCardView(hearingCase: hearingCase)
            }
        }
    }

    private var errorSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 32))
                .foregroundStyle(TribunalTheme.verdictUnsupported)

            Text(viewModel.error ?? "Hearing could not proceed — check your API key or connection.")
                .font(.system(size: 14))
                .foregroundStyle(TribunalTheme.textPrimary)
                .multilineTextAlignment(.center)

            Text("Try starting a new hearing with the same claim.")
                .font(.system(size: 12))
                .foregroundStyle(TribunalTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }
}
