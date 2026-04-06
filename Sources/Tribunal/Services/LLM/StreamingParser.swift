import Foundation

struct StreamingParser {
    static func parseDataLine(_ line: String) -> StreamEvent? {
        guard line.hasPrefix("data: ") else { return nil }
        let data = String(line.dropFirst(6))
        if data == "[DONE]" { return .done }

        guard let jsonData = data.data(using: .utf8),
              let chunk = try? JSONDecoder().decode(OpenAIStreamChunk.self, from: jsonData) else {
            return nil
        }

        if let usage = chunk.usage {
            return .usage(promptTokens: usage.promptTokens, completionTokens: usage.completionTokens)
        }

        if let content = chunk.choices.first?.delta.content, !content.isEmpty {
            return .delta(content)
        }

        return nil
    }
}

struct SectionExtractor {
    struct ExtractedSection {
        let section: HearingSection
        let content: String
    }

    static func extract(from json: String) -> [ExtractedSection] {
        var results: [ExtractedSection] = []
        let allSections = HearingSection.allCases

        for (i, section) in allSections.enumerated() {
            let key = "\"\(section.rawValue)\""
            guard let keyRange = json.range(of: key) else { continue }

            // Find the colon after the key
            let afterKey = json[keyRange.upperBound...]
            guard let colonIdx = afterKey.firstIndex(of: ":") else { continue }
            let afterColon = json[json.index(after: colonIdx)...]
            let trimmed = afterColon.drop(while: { $0 == " " })
            guard !trimmed.isEmpty else { continue }

            // Determine end boundary: next section key or end of string
            var endIdx = json.endIndex
            for nextSection in allSections.suffix(from: allSections.index(after: i)) {
                let nextKey = "\"\(nextSection.rawValue)\""
                if let nextRange = json.range(of: nextKey) {
                    endIdx = nextRange.lowerBound
                    break
                }
            }

            var raw = String(json[trimmed.startIndex..<endIdx])
                .trimmingCharacters(in: .whitespacesAndNewlines)

            // Strip surrounding JSON artifacts for string values
            if raw.hasPrefix("\"") { raw = String(raw.dropFirst()) }
            while raw.hasSuffix(",") || raw.hasSuffix("\"") {
                raw = String(raw.dropLast())
            }
            raw = raw.trimmingCharacters(in: .whitespacesAndNewlines)

            // Unescape JSON strings
            raw = raw
                .replacingOccurrences(of: "\\n", with: "\n")
                .replacingOccurrences(of: "\\t", with: "\t")
                .replacingOccurrences(of: "\\\"", with: "\"")
                .replacingOccurrences(of: "\\\\", with: "\\")

            results.append(ExtractedSection(section: section, content: raw))
        }

        return results
    }
}
