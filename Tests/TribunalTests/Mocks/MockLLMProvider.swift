import Foundation
@testable import Tribunal

final class MockLLMProvider: LLMProvider {
    var events: [StreamEvent] = []
    var error: Error?
    var receivedClaim: String?
    var receivedModel: String?

    func streamHearing(claim: String, model: String) -> AsyncThrowingStream<StreamEvent, Error> {
        receivedClaim = claim
        receivedModel = model
        let events = self.events
        let error = self.error
        return AsyncThrowingStream { continuation in
            Task {
                if let error {
                    continuation.finish(throwing: error)
                    return
                }
                for event in events {
                    continuation.yield(event)
                    try? await Task.sleep(nanoseconds: 1_000_000)
                }
                continuation.finish()
            }
        }
    }
}
