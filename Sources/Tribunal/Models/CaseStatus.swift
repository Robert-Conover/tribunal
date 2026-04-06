import Foundation

enum CaseStatus: String, Codable {
    case inProgress = "in_progress"
    case completed
    case failed
}

enum InputType: String, Codable {
    case text, url
}
