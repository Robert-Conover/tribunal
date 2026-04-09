import SwiftUI

extension View {
    @ViewBuilder
    func tribunalGlassGroup(spacing: CGFloat? = nil) -> some View {
        if #available(macOS 26.0, *) {
            GlassEffectContainer(spacing: spacing) {
                self
            }
        } else {
            self
        }
    }

    @ViewBuilder
    func tribunalGlassCard(
        interactive: Bool = false,
        tint: Color? = nil,
        cornerRadius: CGFloat = 22
    ) -> some View {
        if #available(macOS 26.0, *) {
            if let tint {
                self.glassEffect(
                    (interactive ? Glass.regular.interactive() : .regular).tint(tint),
                    in: ConcentricRectangle(corners: .concentric, isUniform: true)
                )
            } else {
                self.glassEffect(
                    interactive ? Glass.regular.interactive() : .regular,
                    in: ConcentricRectangle(corners: .concentric, isUniform: true)
                )
            }
        } else {
            self
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(.white.opacity(0.08))
                }
        }
    }

    @ViewBuilder
    func tribunalPrimaryButtonStyle() -> some View {
        if #available(macOS 26.0, *) {
            self.buttonStyle(.glassProminent)
        } else {
            self.buttonStyle(.borderedProminent)
        }
    }

    @ViewBuilder
    func tribunalSecondaryButtonStyle() -> some View {
        if #available(macOS 26.0, *) {
            self.buttonStyle(.glass)
        } else {
            self.buttonStyle(.bordered)
        }
    }

    @ViewBuilder
    func tribunalTopScrollEdgeEffect() -> some View {
        if #available(macOS 26.0, *) {
            self.scrollEdgeEffectStyle(.soft, for: .top)
        } else {
            self
        }
    }

    @ViewBuilder
    func tribunalSearchToolbarBehavior() -> some View {
        if #available(macOS 26.0, *) {
            self.searchToolbarBehavior(.automatic)
        } else {
            self
        }
    }
}
