import XCTest
@testable import Tribunal

@MainActor
final class SettingsViewModelTests: XCTestCase {
    func testInitialState() {
        let vm = SettingsViewModel()
        XCTAssertFalse(vm.isValidating)
        XCTAssertNil(vm.validationResult)
    }

    func testSaveKeyUpdatesSettings() throws {
        let defaults = UserDefaults(suiteName: "test.settings.vm")!
        defaults.removePersistentDomain(forName: "test.settings.vm")
        let keychain = MockKeychainService()
        let settings = UserSettings(defaults: defaults, keychain: keychain)
        let vm = SettingsViewModel()

        try vm.saveAPIKey("sk-test-key-123", settings: settings)
        XCTAssertEqual(settings.apiKey, "sk-test-key-123")
        XCTAssertTrue(settings.hasCompletedSetup)
    }

    func testClearKeyUpdatesSettings() throws {
        let defaults = UserDefaults(suiteName: "test.settings.vm2")!
        defaults.removePersistentDomain(forName: "test.settings.vm2")
        let keychain = MockKeychainService()
        let settings = UserSettings(defaults: defaults, keychain: keychain)

        let vm = SettingsViewModel()
        try vm.saveAPIKey("sk-test", settings: settings)
        try vm.clearAPIKey(settings: settings)
        XCTAssertNil(settings.apiKey)
        XCTAssertFalse(settings.hasCompletedSetup)
    }
}
