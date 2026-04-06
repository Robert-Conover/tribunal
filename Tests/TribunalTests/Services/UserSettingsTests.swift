import XCTest
@testable import Tribunal

final class UserSettingsTests: XCTestCase {
    private var defaults: UserDefaults!
    private var keychain: MockKeychainService!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: "test.user.settings")!
        defaults.removePersistentDomain(forName: "test.user.settings")
        keychain = MockKeychainService()
    }

    func testDefaultValues() {
        let settings = UserSettings(defaults: defaults, keychain: keychain)
        XCTAssertEqual(settings.defaultModel, "gpt-5.4-mini")
        XCTAssertEqual(settings.appearance, .system)
        XCTAssertFalse(settings.hasCompletedSetup)
        XCTAssertNil(settings.apiKey)
    }

    func testSetApiKey() throws {
        let settings = UserSettings(defaults: defaults, keychain: keychain)
        try settings.setApiKey("sk-test")
        XCTAssertEqual(settings.apiKey, "sk-test")
        XCTAssertTrue(settings.hasCompletedSetup)
    }

    func testClearApiKey() throws {
        let settings = UserSettings(defaults: defaults, keychain: keychain)
        try settings.setApiKey("sk-test")
        try settings.clearApiKey()
        XCTAssertNil(settings.apiKey)
        XCTAssertFalse(settings.hasCompletedSetup)
    }

    func testModelPersistence() {
        let settings = UserSettings(defaults: defaults, keychain: keychain)
        settings.defaultModel = "gpt-5.4"
        let reloaded = UserSettings(defaults: defaults, keychain: keychain)
        XCTAssertEqual(reloaded.defaultModel, "gpt-5.4")
    }

    func testAppearancePersistence() {
        let settings = UserSettings(defaults: defaults, keychain: keychain)
        settings.appearance = .dark
        let reloaded = UserSettings(defaults: defaults, keychain: keychain)
        XCTAssertEqual(reloaded.appearance, .dark)
    }
}
