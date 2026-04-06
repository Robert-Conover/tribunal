import Foundation
import Combine

enum AppearanceMode: String, CaseIterable {
    case system, dark, light
    var displayName: String { rawValue.capitalized }
}

final class UserSettings: ObservableObject {
    private let defaults: UserDefaults
    private let keychain: KeychainServiceProtocol

    private static let modelKey = "tribunal.defaultModel"
    private static let appearanceKey = "tribunal.appearance"
    private static let setupCompleteKey = "tribunal.hasCompletedSetup"
    private static let apiKeyAccount = "openai_api_key"

    @Published var defaultModel: String {
        didSet { defaults.set(defaultModel, forKey: Self.modelKey) }
    }

    @Published var appearance: AppearanceMode {
        didSet { defaults.set(appearance.rawValue, forKey: Self.appearanceKey) }
    }

    @Published var hasCompletedSetup: Bool {
        didSet { defaults.set(hasCompletedSetup, forKey: Self.setupCompleteKey) }
    }

    init(defaults: UserDefaults = .standard, keychain: KeychainServiceProtocol = KeychainService()) {
        self.defaults = defaults
        self.keychain = keychain
        self.defaultModel = defaults.string(forKey: Self.modelKey) ?? "gpt-5.4-mini"
        self.appearance = AppearanceMode(rawValue: defaults.string(forKey: Self.appearanceKey) ?? "system") ?? .system
        self.hasCompletedSetup = defaults.bool(forKey: Self.setupCompleteKey)
    }

    var apiKey: String? {
        try? keychain.load(for: Self.apiKeyAccount)
    }

    func setApiKey(_ key: String) throws {
        try keychain.save(key, for: Self.apiKeyAccount)
        hasCompletedSetup = true
    }

    func clearApiKey() throws {
        try keychain.delete(for: Self.apiKeyAccount)
        hasCompletedSetup = false
    }
}
