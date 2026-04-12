import SwiftUI
import MicroUICore

struct ProfileTileView: View {

    @Injected(\.profileNavigationCoordinator) private var coordinator

    var body: some View {
        Button { coordinator.present() } label: {
            VStack(spacing: OwlsSpacing.sm) {
                ZStack {
                    Circle()
                        .fill(OwlsColor.primary)
                        .frame(width: 40, height: 40)
                    Text("PB")
                        .font(OwlsTypography.callout)
                        .foregroundStyle(.white)
                }

                Text("Profile")
                    .font(OwlsTypography.headline)
                    .foregroundStyle(OwlsColor.label)

                Text("View profile")
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
