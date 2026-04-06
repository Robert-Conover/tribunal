import XCTest
@testable import Tribunal

final class KeychainServiceTests: XCTestCase {
    func testMockSaveAndLoad() throws {
        let mock = MockKeychainService()
        try mock.save("sk-test-key", for: "api_key")
        let loaded = try mock.load(for: "api_key")
        XCTAssertEqual(loaded, "sk-test-key")
    }

    func testMockLoadMissingKey() throws {
        let mock = MockKeychainService()
        let loaded = try mock.load(for: "nonexistent")
        XCTAssertNil(loaded)
    }

    func testMockDelete() throws {
        let mock = MockKeychainService()
        try mock.save("value", for: "key")
        try mock.delete(for: "key")
        let loaded = try mock.load(for: "key")
        XCTAssertNil(loaded)
    }

    func testMockOverwrite() throws {
        let mock = MockKeychainService()
        try mock.save("first", for: "key")
        try mock.save("second", for: "key")
        let loaded = try mock.load(for: "key")
        XCTAssertEqual(loaded, "second")
    }
}
