import SwiftUI

struct InputView: View {
    @State private var claimText = ""
    @FocusState private var isInputFocused: Bool
    let onSubmit: (String) -> Void

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Text("Tribunal")
                .font(.system(size: 36, weight: .light, design: .serif))
                .foregroundStyle(TribunalTheme.textPrimary)

            Text("Paste a claim, link, or text to open a hearing")
                .font(.system(size: 14))
                .foregroundStyle(TribunalTheme.textSecondary)

            VStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Label("Case Intake", systemImage: "text.quote")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(TribunalTheme.textSecondary)

                        Spacer()

                        Text("Command-Return")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(TribunalTheme.textSecondary)
                    }

                    TextEditor(text: $claimText)
                        .font(.system(size: 15))
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 130, maxHeight: 240)
                        .focused($isInputFocused)
                }
                .padding(20)
                .tribunalGlassCard(interactive: true)

                Button(action: submitClaim) {
                    Label("Open Hearing", systemImage: "arrow.up.forward.app")
                        .frame(minWidth: 180)
                }
                .controlSize(.large)
                .tribunalPrimaryButtonStyle()
                .tint(TribunalTheme.accent)
                .disabled(claimText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .keyboardShortcut(.return, modifiers: .command)
            }
            .frame(maxWidth: 600)
            .tribunalGlassGroup(spacing: 14)

            Spacer()
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("New Hearing")
        .onAppear {
            DispatchQueue.main.async {
                isInputFocused = true
            }
        }
    }

    private func submitClaim() {
        let trimmed = claimText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        onSubmit(trimmed)
    }
}
