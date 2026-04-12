import SwiftUI
import MicroUICore
import Factory

struct AuthTileView: View {

    @Injected(\.authNavigationCoordinator) private var coordinator
    @Injected(\.authTokenProvider) private var authProvider

    var body: some View {
        Button { coordinator.present() } label: {
            VStack(spacing: OwlsSpacing.sm) {
                Image(systemName: isLoggedIn ? "lock.open.fill" : "lock.fill")
                    .font(.title)
                    .foregroundStyle(isLoggedIn ? .green : OwlsColor.primary)

                Text(isLoggedIn ? "Signed In" : "Sign In")
                    .font(OwlsTypography.headline)
                    .foregroundStyle(OwlsColor.label)

                Text(isLoggedIn ? "Manage session" : "Authenticate")
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

    private var isLoggedIn: Bool {
        authProvider?.isAuthenticated ?? false
    }
}
