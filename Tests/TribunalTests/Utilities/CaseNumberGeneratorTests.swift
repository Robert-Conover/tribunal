import XCTest
@testable import Tribunal

final class CaseNumberGeneratorTests: XCTestCase {
    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "tribunal.caseNumberCounter")
    }

    func testGenerateFormat() {
        let calendar = Calendar.current
        let components = DateComponents(year: 2026, month: 4, day: 6)
        let date = calendar.date(from: components)!
        let result = CaseNumberGenerator.generate(date: date)
        XCTAssertTrue(result.hasPrefix("2026-0406-"), "Got: \(result)")
    }

    func testGenerateIncrementsCounter() {
        let date = Date()
        let first = CaseNumberGenerator.generate(date: date)
        let second = CaseNumberGenerator.generate(date: date)
        XCTAssertNotEqual(first, second)

        let firstNum = Int(first.suffix(3))!
        let secondNum = Int(second.suffix(3))!
        XCTAssertEqual(secondNum, firstNum + 1)
    }

    func testGenerateThreeDigitPadding() {
        let date = Date()
        let result = CaseNumberGenerator.generate(date: date)
        let counter = String(result.suffix(3))
        XCTAssertEqual(counter.count, 3)
    }
}
