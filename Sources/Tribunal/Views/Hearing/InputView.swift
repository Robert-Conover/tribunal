import SwiftUI

struct InputView: View {
    @State private var claimText = ""
    @FocusState private var isInputFocused: Bool
    let onSubmit: (String) -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("Tribunal")
                .font(.system(size: 36, weight: .light, design: .serif))
                .foregroundStyle(TribunalTheme.textPrimary)

            Text("Paste a claim, link, or text to open a hearing")
                .font(.system(size: 14))
                .foregroundStyle(TribunalTheme.textSecondary)

            VStack(spacing: 12) {
                TextEditor(text: $claimText)
                    .font(.system(size: 14))
                    .scrollContentBackground(.hidden)
                    .padding(12)
                    .background(TribunalTheme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(TribunalTheme.textSecondary.opacity(0.3), lineWidth: 1)
                            .allowsHitTesting(false)
                    )
                    .frame(minHeight: 100, maxHeight: 200)
                    .focused($isInputFocused)

                Button(action: submitClaim) {
                    HStack(spacing: 6) {
                        Text("Open Hearing")
                        Text("\u{2318}\u{21A9}")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                    }
                    .frame(minWidth: 160)
                }
                .buttonStyle(.borderedProminent)
                .tint(TribunalTheme.accent)
                .disabled(claimText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .keyboardShortcut(.return, modifiers: .command)
            }
            .frame(maxWidth: 600)

            Spacer()
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(TribunalTheme.background)
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
