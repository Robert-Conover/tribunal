@testable import Tribunal

final class MockKeychainService: KeychainServiceProtocol {
    var store: [String: String] = [:]

    func save(_ value: String, for key: String) throws {
        store[key] = value
    }

    func load(for key: String) throws -> String? {
        store[key]
    }

    func delete(for key: String) throws {
        store.removeValue(forKey: key)
    }
}
