import SwiftUI
import SwiftData

struct SessionView: View {
    let hearingCase: Case
    @ObservedObject var viewModel: HearingViewModel
    let onRetry: () -> Void
    @Environment(\.modelContext) private var modelContext

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

            Text(primaryErrorMessage)
                .font(.system(size: 14))
                .foregroundStyle(TribunalTheme.textPrimary)
                .multilineTextAlignment(.center)

            Text(secondaryErrorMessage)
                .font(.system(size: 12))
                .foregroundStyle(TribunalTheme.textSecondary)
                .multilineTextAlignment(.center)

            Button("Retry Hearing") {
                retryHearing()
            }
            .buttonStyle(.borderedProminent)
            .tint(TribunalTheme.accent)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }

    private var primaryErrorMessage: String {
        switch viewModel.failureKind {
        case .missingAPIKey:
            return "No API key configured. Add your OpenAI API key in Settings to continue."
        case .invalidAPIKey:
            return "Hearing could not proceed — your API key was rejected."
        case .network:
            return "No connection. Tribunal requires internet access to conduct hearings."
        case .api:
            return "Hearing could not proceed — OpenAI returned an API error."
        case .unknown:
            return viewModel.error ?? "Hearing could not proceed — check your API key or connection."
        case nil:
            return "Hearing could not proceed — check your API key or connection."
        }
    }

    private var secondaryErrorMessage: String {
        switch viewModel.failureKind {
        case .missingAPIKey, .invalidAPIKey:
            return "Update your API key in Settings, then retry this hearing."
        case .network:
            return "Reconnect to the internet, then try the same claim again."
        case .api, .unknown, nil:
            return "Try starting a new hearing with the same claim."
        }
    }

    private func retryHearing() {
        onRetry()
        Task {
            await viewModel.retryHearing(from: hearingCase, modelContext: modelContext)
        }
    }
}
