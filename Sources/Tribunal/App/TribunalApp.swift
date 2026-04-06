import SwiftUI
import SwiftData

@main
struct TribunalApp: App {
    @StateObject private var settings = UserSettings()

    var body: some Scene {
        WindowGroup {
            ContentView(
                llmProvider: OpenAIService(
                    apiKeyProvider: { [weak settings] in settings?.apiKey }
                )
            )
            .environmentObject(settings)
        }
        .modelContainer(for: Case.self)
        .defaultSize(width: 1100, height: 750)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Hearing") {
                    NotificationCenter.default.post(name: .newHearing, object: nil)
                }
                .keyboardShortcut("n", modifiers: .command)
            }
        }
    }
}

extension Notification.Name {
    static let newHearing = Notification.Name("tribunal.newHearing")
}
