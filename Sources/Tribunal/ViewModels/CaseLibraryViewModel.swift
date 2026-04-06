import Foundation
import SwiftData

@MainActor
final class CaseLibraryViewModel: ObservableObject {
    func deleteCase(_ hearingCase: Case, modelContext: ModelContext) {
        modelContext.delete(hearingCase)
    }

    func deleteCases(_ cases: [Case], modelContext: ModelContext) {
        for c in cases {
            modelContext.delete(c)
        }
    }
}
