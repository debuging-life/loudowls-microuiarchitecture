import SwiftUI
import MicroUICore

// MARK: - Tile View
// Embeddable widget — drop into another module's screen via TileBuilder.

struct FavoriteScreenTileView: View {

    var body: some View {
        VStack(spacing: OwlsSpacing.sm) {
            Image(systemName: "heart.fill")
                .font(.title)
                .foregroundStyle(OwlsColor.primary)

            Text("Favorites")
                .font(OwlsTypography.headline)
                .foregroundStyle(OwlsColor.label)

            Text("View saved")
                .font(OwlsTypography.caption)
                .foregroundStyle(OwlsColor.secondaryLabel)
        }
        .frame(maxWidth: .infinity)
        .padding(OwlsSpacing.lg)
        .background(OwlsColor.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: OwlsRadius.lg))
    }
}
