import SwiftUI
import MicroUICore

struct UnknowTileView: View {

    var body: some View {
        VStack(spacing: OwlsSpacing.sm) {
            Image(systemName: "questionmark.circle.fill")
                .font(.title)
                .foregroundStyle(OwlsColor.primary)

            Text("Unknow")
                .font(OwlsTypography.headline)
                .foregroundStyle(OwlsColor.label)

            Text("View Unknow")
                .font(OwlsTypography.caption)
                .foregroundStyle(OwlsColor.secondaryLabel)
        }
        .frame(maxWidth: .infinity)
        .padding(OwlsSpacing.lg)
        .background(OwlsColor.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: OwlsRadius.lg))
    }
}
