import XCTest
@testable import Tribunal

final class StreamingParserTests: XCTestCase {
    func testParseContentDelta() {
        let line = """
        data: {"choices":[{"delta":{"content":"Hello"},"finish_reason":null}],"usage":null}
        """
        let event = StreamingParser.parseDataLine(line)
        if case .delta(let content) = event {
            XCTAssertEqual(content, "Hello")
        } else {
            XCTFail("Expected delta event, got \(String(describing: event))")
        }
    }

    func testParseDone() {
        let event = StreamingParser.parseDataLine("data: [DONE]")
        if case .done = event {
            // pass
        } else {
            XCTFail("Expected done event")
        }
    }

    func testParseUsage() {
        let line = """
        data: {"choices":[{"delta":{},"finish_reason":"stop"}],"usage":{"prompt_tokens":100,"completion_tokens":500}}
        """
        let event = StreamingParser.parseDataLine(line)
        if case .usage(let prompt, let completion) = event {
            XCTAssertEqual(prompt, 100)
            XCTAssertEqual(completion, 500)
        } else {
            XCTFail("Expected usage event, got \(String(describing: event))")
        }
    }

    func testParseEmptyDelta() {
        let line = """
        data: {"choices":[{"delta":{},"finish_reason":null}],"usage":null}
        """
        let event = StreamingParser.parseDataLine(line)
        XCTAssertNil(event)
    }

    func testParseNonDataLine() {
        XCTAssertNil(StreamingParser.parseDataLine("event: ping"))
        XCTAssertNil(StreamingParser.parseDataLine(""))
        XCTAssertNil(StreamingParser.parseDataLine("id: 123"))
    }

    func testParseInvalidJSON() {
        let event = StreamingParser.parseDataLine("data: {invalid json}")
        XCTAssertNil(event)
    }

    // SectionExtractor tests
    func testExtractSingleSection() {
        let json = """
        {"claim_summary": "The claim states X
        """
        let sections = SectionExtractor.extract(from: json)
        XCTAssertEqual(sections.count, 1)
        XCTAssertEqual(sections.first?.section, .claimSummary)
        XCTAssertTrue(sections.first?.content.contains("The claim states X") ?? false)
    }

    func testExtractMultipleSections() {
        let json = """
        {"claim_summary": "Summary here", "prosecution": "Against the claim
        """
        let sections = SectionExtractor.extract(from: json)
        XCTAssertEqual(sections.count, 2)
        XCTAssertEqual(sections[0].section, .claimSummary)
        XCTAssertEqual(sections[0].content, "Summary here")
        XCTAssertEqual(sections[1].section, .prosecution)
        XCTAssertTrue(sections[1].content.contains("Against the claim"))
    }

    func testExtractHandlesEscapedCharacters() {
        let json = """
        {"claim_summary": "Line one\\nLine two", "prosecution": "test
        """
        let sections = SectionExtractor.extract(from: json)
        XCTAssertEqual(sections.first?.content, "Line one\nLine two")
    }
}
