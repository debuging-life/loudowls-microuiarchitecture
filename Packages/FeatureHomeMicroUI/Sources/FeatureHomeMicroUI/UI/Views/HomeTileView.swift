import SwiftUI
import MicroUICore

struct HomeTileView: View {

    @Injected(\.homeNavigationCoordinator) private var coordinator

    var body: some View {
        Button { coordinator.present() } label: {
            VStack(spacing: OwlsSpacing.sm) {
                Image(systemName: "house.fill")
                    .font(.title)
                    .foregroundStyle(OwlsColor.primary)

                Text("Home")
                    .font(OwlsTypography.headline)
                    .foregroundStyle(OwlsColor.label)

                Text("View accounts")
                    .font(OwlsTypography.caption)
                    .foregroundStyle(OwlsColor.secondaryLabel)
            }
            .frame(maxWidth: .infinity)
            .padding(OwlsSpacing.lg)
            .background(OwlsColor.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: OwlsRadius.lg))
        }
        .buttonStyle(.plain)
    }
}
