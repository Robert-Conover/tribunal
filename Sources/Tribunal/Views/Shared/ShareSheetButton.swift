import SwiftUI

struct ShareSheetButton<Label: View>: View {
    let item: String
    let label: () -> Label

    init(item: String, @ViewBuilder label: @escaping () -> Label) {
        self.item = item
        self.label = label
    }

    var body: some View {
        ShareLink(item: item) {
            label()
        }
        .tribunalSecondaryButtonStyle()
        .tint(TribunalTheme.accent)
    }
}
