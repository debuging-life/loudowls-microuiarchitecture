import SwiftUI
import MicroUICore

struct AboutScreenTileView: View {

    var body: some View {
        VStack(spacing: OwlsSpacing.sm) {
            Image(systemName: "square.grid.2x2")
                .font(.title)
                .foregroundStyle(OwlsColor.primary)

            Text("AboutScreen")
                .font(OwlsTypography.headline)
                .foregroundStyle(OwlsColor.label)
        }
        .frame(maxWidth: .infinity)
        .padding(OwlsSpacing.lg)
        .background(OwlsColor.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: OwlsRadius.lg))
    }
}
