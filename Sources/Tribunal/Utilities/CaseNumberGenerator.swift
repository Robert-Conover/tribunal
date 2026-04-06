import Foundation

struct CaseNumberGenerator {
    private static let counterKey = "tribunal.caseNumberCounter"

    static func generate(date: Date = Date(), defaults: UserDefaults = .standard) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMdd"
        let datePart = formatter.string(from: date)
        let counter = defaults.integer(forKey: counterKey) + 1
        defaults.set(counter, forKey: counterKey)
        return "\(datePart)-\(String(format: "%03d", counter % 1000))"
    }
}
