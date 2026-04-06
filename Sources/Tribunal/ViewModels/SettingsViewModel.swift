import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var isValidating = false
    @Published var validationResult: Bool?
    @Published var validationError: String?
    @Published var apiKeyInput = ""

    func saveAPIKey(_ key: String, settings: UserSettings) throws {
        try settings.setApiKey(key)
    }

    func clearAPIKey(settings: UserSettings) throws {
        try settings.clearApiKey()
        apiKeyInput = ""
        validationResult = nil
    }

    func validateAndSave(settings: UserSettings) async {
        let key = apiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !key.isEmpty else {
            validationError = "Please enter an API key"
            return
        }

        isValidating = true
        validationError = nil
        validationResult = nil

        do {
            let service = OpenAIService(apiKeyProvider: { key })
            let valid = try await service.validateAPIKey(key)
            if valid {
                try settings.setApiKey(key)
                validationResult = true
            } else {
                validationResult = false
                validationError = "API key is invalid"
            }
        } catch {
            validationResult = false
            validationError = error.localizedDescription
        }

        isValidating = false
    }
}
