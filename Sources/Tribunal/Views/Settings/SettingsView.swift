import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: UserSettings
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showWhyAPIKey = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                Text("Settings")
                    .font(.system(size: 24, weight: .medium, design: .serif))
                    .foregroundStyle(TribunalTheme.textPrimary)

                // API Configuration
                VStack(alignment: .leading, spacing: 16) {
                    Text("API CONFIGURATION")
                        .font(.system(size: 11, weight: .bold))
                        .tracking(1)
                        .foregroundStyle(TribunalTheme.textSecondary)

                    Text("Tribunal uses OpenAI to analyze claims. Paste your API key to get started.")
                        .font(.system(size: 13))
                        .foregroundStyle(TribunalTheme.textSecondary)

                    HStack(spacing: 8) {
                        SecureField("sk-...", text: $viewModel.apiKeyInput)
                            .textFieldStyle(.roundedBorder)
                            .frame(maxWidth: 400)

                        Button(viewModel.isValidating ? "Validating..." : "Save Key") {
                            Task { await viewModel.validateAndSave(settings: settings) }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(TribunalTheme.accent)
                        .disabled(viewModel.isValidating || viewModel.apiKeyInput.isEmpty)
                    }

                    if let result = viewModel.validationResult {
                        HStack(spacing: 6) {
                            Image(systemName: result ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundStyle(result ? TribunalTheme.verdictSupported : TribunalTheme.verdictUnsupported)
                            Text(result ? "API key verified and saved" : (viewModel.validationError ?? "Invalid API key"))
                                .font(.system(size: 13))
                                .foregroundStyle(result ? TribunalTheme.verdictSupported : TribunalTheme.verdictUnsupported)
                        }
                    }

                    if settings.hasCompletedSetup {
                        Button("Clear API Key", role: .destructive) {
                            try? viewModel.clearAPIKey(settings: settings)
                        }
                        .font(.system(size: 12))
                    }

                    Link("Get an OpenAI API key \u{2192}", destination: URL(string: "https://platform.openai.com/api-keys")!)
                        .font(.system(size: 12))
                        .foregroundStyle(TribunalTheme.accent)

                    DisclosureGroup("Why do I need an API key?", isExpanded: $showWhyAPIKey) {
                        Text("Tribunal sends your claims to OpenAI's API for analysis. You pay OpenAI directly for usage — Tribunal has no server costs and no subscription. A typical hearing costs less than $0.01 with gpt-5.4-mini.")
                            .font(.system(size: 13))
                            .foregroundStyle(TribunalTheme.textSecondary)
                            .padding(.top, 4)
                    }
                    .font(.system(size: 13))
                    .foregroundStyle(TribunalTheme.accent)
                }

                Divider()

                // Model Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("MODEL")
                        .font(.system(size: 11, weight: .bold))
                        .tracking(1)
                        .foregroundStyle(TribunalTheme.textSecondary)

                    Picker("Default model", selection: $settings.defaultModel) {
                        Text("gpt-5.4-mini — Recommended").tag("gpt-5.4-mini")
                        Text("gpt-5.4 — Deeper analysis").tag("gpt-5.4")
                    }
                    .pickerStyle(.radioGroup)
                    .foregroundStyle(TribunalTheme.textPrimary)
                }

                Divider()

                // Appearance
                VStack(alignment: .leading, spacing: 12) {
                    Text("APPEARANCE")
                        .font(.system(size: 11, weight: .bold))
                        .tracking(1)
                        .foregroundStyle(TribunalTheme.textSecondary)

                    Picker("Appearance", selection: $settings.appearance) {
                        ForEach(AppearanceMode.allCases, id: \.self) { mode in
                            Text(mode.displayName).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 300)
                }

                Divider()

                // About
                VStack(alignment: .leading, spacing: 8) {
                    Text("ABOUT")
                        .font(.system(size: 11, weight: .bold))
                        .tracking(1)
                        .foregroundStyle(TribunalTheme.textSecondary)

                    Text("Tribunal v1.0")
                        .font(.system(size: 13))
                        .foregroundStyle(TribunalTheme.textPrimary)

                    Text("Tribunal uses AI to structure claim analysis. It is not a fact-checker, court of law, or source of truth. All analyses reflect the model's reasoning at the time of the hearing.")
                        .font(.system(size: 12))
                        .foregroundStyle(TribunalTheme.textSecondary)
                        .lineSpacing(3)
                }
            }
            .padding(32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(TribunalTheme.background)
        .onAppear {
            if let key = settings.apiKey {
                viewModel.apiKeyInput = key
            }
        }
    }
}
