import SwiftUI
import SwiftData
import AppKit

@main
struct TribunalApp: App {
    @NSApplicationDelegateAdaptor(TribunalAppDelegate.self) private var appDelegate
    @StateObject private var settings = UserSettings()
    
    init() {
        // SwiftUI apps launched via `swift run` can start without normal app activation,
        // which prevents text inputs from receiving keyboard focus.
        DispatchQueue.main.async {
            ensureTribunalAppIsActive()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(
                llmProvider: OpenAIService(
                    apiKeyProvider: { [weak settings] in settings?.apiKey }
                )
            )
            .environmentObject(settings)
            .onAppear {
                ensureTribunalAppIsActive()
            }
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

private final class TribunalAppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        ensureTribunalAppIsActive()
        applyTribunalAppIconIfAvailable()
    }
}

private func ensureTribunalAppIsActive() {
    NSApp.setActivationPolicy(.regular)
    NSApp.activate(ignoringOtherApps: true)
    NSApp.windows.first?.makeKeyAndOrderFront(nil)
}

private func applyTribunalAppIconIfAvailable() {
    guard let iconURL = Bundle.module.url(forResource: "AppIconDock", withExtension: "png"),
          let iconImage = NSImage(contentsOf: iconURL) else {
        return
    }

    NSApp.applicationIconImage = iconImage
}

extension Notification.Name {
    static let newHearing = Notification.Name("tribunal.newHearing")
}
