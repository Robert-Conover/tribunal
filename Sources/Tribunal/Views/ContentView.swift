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

    init(llmProvider: any LLMProvider) {
        _hearingVM = StateObject(wrappedValue: HearingViewModel(llmProvider: llmProvider))
    }

    private var displayedCase: Case? {
        if let id = selectedCaseID {
            return cases.first { $0.id == id }
        }
        return hearingVM.currentCase
    }

    var body: some View {
        NavigationSplitView {
            SidebarView(
                cases: cases,
                selectedCaseID: $selectedCaseID,
                onNewHearing: {
                    showSettings = false
                    selectedCaseID = nil
                    hearingVM.reset()
                },
                onShowSettings: {
                    showSettings = true
                    selectedCaseID = nil
                },
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
                SessionView(hearingCase: activeCase, viewModel: hearingVM)
            } else {
                InputView { claim in
                    guard settings.apiKey != nil else {
                        showSettings = true
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
        .preferredColorScheme(colorScheme)
        .onChange(of: selectedCaseID) {
            if selectedCaseID != nil {
                showSettings = false
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .newHearing)) { _ in
            showSettings = false
            selectedCaseID = nil
            hearingVM.reset()
        }
    }

    private var colorScheme: ColorScheme? {
        switch settings.appearance {
        case .dark: .dark
        case .light: .light
        case .system: nil
        }
    }
}
