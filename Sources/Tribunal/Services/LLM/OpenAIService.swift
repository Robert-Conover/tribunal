import Foundation

enum OpenAIError: Error, LocalizedError {
    case noAPIKey
    case invalidAPIKey
    case networkError(Error)
    case httpError(Int, String)
    case streamingError(String)

    var errorDescription: String? {
        switch self {
        case .noAPIKey: "No API key configured. Add your OpenAI API key in Settings."
        case .invalidAPIKey: "Invalid API key. Check your key in Settings."
        case .networkError(let error): "Network error: \(error.localizedDescription)"
        case .httpError(let code, let message): "API error (\(code)): \(message)"
        case .streamingError(let message): "Streaming error: \(message)"
        }
    }
}

struct OpenAIService: LLMProvider {
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    private let session: URLSession
    private let apiKeyProvider: () -> String?

    init(session: URLSession = .shared, apiKeyProvider: @escaping () -> String?) {
        self.session = session
        self.apiKeyProvider = apiKeyProvider
    }

    func streamHearing(claim: String, model: String) -> AsyncThrowingStream<StreamEvent, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    guard let apiKey = apiKeyProvider() else {
                        throw OpenAIError.noAPIKey
                    }
                    let prompt = HearingPrompt.build(claim: claim)
                    let request = try buildRequest(
                        apiKey: apiKey, model: model,
                        systemPrompt: prompt.system, userMessage: prompt.user
                    )
                    let (bytes, response) = try await session.bytes(for: request)
                    guard let http = response as? HTTPURLResponse else {
                        throw OpenAIError.streamingError("Invalid response")
                    }
                    if http.statusCode == 401 { throw OpenAIError.invalidAPIKey }
                    guard http.statusCode == 200 else {
                        throw OpenAIError.httpError(http.statusCode, "Request failed")
                    }

                    for try await line in bytes.lines {
                        if let event = StreamingParser.parseDataLine(line) {
                            continuation.yield(event)
                            if case .done = event { break }
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    func validateAPIKey(_ key: String) async throws -> Bool {
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/models")!)
        request.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        let (_, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { return false }
        return http.statusCode == 200
    }

    private func buildRequest(apiKey: String, model: String, systemPrompt: String, userMessage: String) throws -> URLRequest {
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "model": model,
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": userMessage]
            ],
            "stream": true,
            "stream_options": ["include_usage": true],
            "response_format": ["type": "json_object"]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        return request
    }
}
