import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject private var settings: UserSettings
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Case.createdAt, order: .reverse) private var cases: [Case]

    @StateObject private var hearingVM: HearingViewModel
    @StateObject private var libraryVM = CaseLibraryViewModel()
    @State private var selectedCaseID: UUID?
    @State private var showSettings = false
    @State private var caseSearchText = ""

    init(llmProvider: any LLMProvider) {
        _hearingVM = StateObject(wrappedValue: HearingViewModel(llmProvider: llmProvider))
    }

    private var displayedCase: Case? {
        if let id = selectedCaseID {
            return cases.first { $0.id == id }
        }
        return hearingVM.currentCase
    }

    private var filteredCases: [Case] {
        let query = caseSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return cases }

        return cases.filter { hearingCase in
            hearingCase.caseNumber.localizedCaseInsensitiveContains(query) ||
            hearingCase.rawContent.localizedCaseInsensitiveContains(query) ||
            hearingCase.claimSummary.localizedCaseInsensitiveContains(query) ||
            hearingCase.verdictSummary.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        NavigationSplitView {
            SidebarView(
                cases: filteredCases,
                searchText: caseSearchText,
                selectedCaseID: $selectedCaseID,
                onDelete: { hearingCase in
                    libraryVM.deleteCase(hearingCase, modelContext: modelContext)
                    if selectedCaseID == hearingCase.id {
                        selectedCaseID = nil
                    }
                }
            )
            .frame(minWidth: 220, idealWidth: 260, maxWidth: 350)
        } detail: {
            if showSettings {
                SettingsView()
            } else if let activeCase = displayedCase {
                SessionView(
                    hearingCase: activeCase,
                    viewModel: hearingVM,
                    onRetry: {
                        showSettings = false
                        selectedCaseID = nil
                    }
                )
            } else {
                InputView { claim in
                    guard settings.apiKey != nil else {
                        openSettings()
                        return
                    }
                    showSettings = false
                    Task {
                        await hearingVM.startHearing(
                            claim: claim,
                            model: settings.defaultModel,
                            modelContext: modelContext
                        )
                    }
                }
            }
        }
        .frame(minWidth: 800, minHeight: 600)
        .searchable(text: $caseSearchText, prompt: "Search cases")
        .tribunalSearchToolbarBehavior()
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    startNewHearing()
                } label: {
                    Label("New Hearing", systemImage: "plus")
                }
            }

            if #available(macOS 26.0, *) {
                ToolbarSpacer(.flexible, placement: .automatic)
            }

            ToolbarItem(placement: .automatic) {
                Button {
                    openSettings()
                } label: {
                    Label("Settings", systemImage: "gearshape")
                }
            }
        }
        .preferredColorScheme(colorScheme)
        .onChange(of: selectedCaseID) {
            if selectedCaseID != nil {
                showSettings = false
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .newHearing)) { _ in
            startNewHearing()
        }
    }

    private var colorScheme: ColorScheme? {
        switch settings.appearance {
        case .dark: .dark
        case .light: .light
        case .system: nil
        }
    }

    private func startNewHearing() {
        showSettings = false
        selectedCaseID = nil
        hearingVM.reset()
    }

    private func openSettings() {
        showSettings = true
        selectedCaseID = nil
    }
}
