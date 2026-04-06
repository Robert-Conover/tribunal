import SwiftUI
import SwiftData

struct SidebarView: View {
    let cases: [Case]
    @Binding var selectedCaseID: UUID?
    let onNewHearing: () -> Void
    let onShowSettings: () -> Void
    let onDelete: (Case) -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Tribunal")
                    .font(.system(size: 16, weight: .semibold, design: .serif))
                    .foregroundStyle(TribunalTheme.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)

            // New Hearing button
            Button(action: onNewHearing) {
                Label("New Hearing", systemImage: "plus")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(TribunalTheme.accent)
            .padding(.horizontal, 12)
            .padding(.bottom, 12)

            Divider()

            // Case list
            if cases.isEmpty {
                Spacer()
                Text("Your case library\nwill appear here")
                    .font(.system(size: 13))
                    .foregroundStyle(TribunalTheme.textSecondary)
                    .multilineTextAlignment(.center)
                Spacer()
            } else {
                Text("RECENT CASES")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(TribunalTheme.textSecondary)
                    .tracking(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 4)

                List(selection: $selectedCaseID) {
                    ForEach(cases) { hearingCase in
                        CaseRowView(hearingCase: hearingCase)
                            .tag(hearingCase.id)
                            .contextMenu {
                                Button("Delete Case", role: .destructive) {
                                    onDelete(hearingCase)
                                }
                            }
                    }
                }
                .listStyle(.sidebar)
            }

            Divider()

            // Settings link
            Button(action: onShowSettings) {
                Label("Settings", systemImage: "gear")
                    .font(.system(size: 13))
                    .foregroundStyle(TribunalTheme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
    }
}
