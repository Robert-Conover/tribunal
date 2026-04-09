import SwiftUI
import SwiftData

struct SidebarView: View {
    let cases: [Case]
    let searchText: String
    @Binding var selectedCaseID: UUID?
    let onDelete: (Case) -> Void

    var body: some View {
        List(selection: $selectedCaseID) {
            if !cases.isEmpty {
                Section("Recent Cases") {
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
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Tribunal")
        .overlay {
            if cases.isEmpty {
                ContentUnavailableView(
                    searchText.isEmpty ? "No Hearings Yet" : "No Matching Cases",
                    systemImage: searchText.isEmpty ? "building.columns" : "magnifyingglass",
                    description: Text(
                        searchText.isEmpty
                        ? "Start a hearing to build your library."
                        : "Try a different title, case number, or phrase."
                    )
                )
            }
        }
    }
}
