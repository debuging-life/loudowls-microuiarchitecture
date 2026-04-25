import SwiftUI
import MicroUICore

struct OwlScreenTileView: View {

    @Injected(\.owlscreenNavigationCoordinator) private var coordinator

    var body: some View {
        Button { coordinator.present() } label: {
            VStack(spacing: OwlsSpacing.sm) {
                Image(systemName: "square.grid.2x2")
                    .font(.title)
                    .foregroundStyle(OwlsColor.primary)

                Text("OwlScreen")
                    .font(OwlsTypography.headline)
                    .foregroundStyle(OwlsColor.label)

                Text("View OwlScreen")
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