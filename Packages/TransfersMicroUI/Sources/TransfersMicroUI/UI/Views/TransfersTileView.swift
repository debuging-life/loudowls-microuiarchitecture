import SwiftUI
import MicroUICore

struct TransfersTileView: View {

    @Injected(\.transfersNavigationCoordinator) private var coordinator

    var body: some View {
        Button { coordinator.present() } label: {
            VStack(spacing: OwlsSpacing.sm) {
                Image(systemName: "square.grid.2x2")
                    .font(.title)
                    .foregroundStyle(OwlsColor.primary)

                Text("Transfers")
                    .font(OwlsTypography.headline)
                    .foregroundStyle(OwlsColor.label)

                Text("View Transfers")
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
