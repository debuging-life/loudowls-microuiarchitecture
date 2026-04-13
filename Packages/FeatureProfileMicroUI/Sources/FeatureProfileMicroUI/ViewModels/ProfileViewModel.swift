import Foundation
import Observation
import MicroUICore
import Factory

@Observable
final class ProfileViewModel {

    private(set) var profile: UserProfile?
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    var isLogoutConfirmPresented = false

    private let repository: ProfileRepository

    init(repository: ProfileRepository) {
        self.repository = repository
    }

    // MARK: - Load

    func loadProfile() async {
        isLoading = true
        errorMessage = nil
        do {
            profile = try await repository.loadProfile()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: - Logout

    func logout() {
        Container.shared.authTokenProvider.register { nil }
        OwlsKeychain.shared.delete(OwlsKeychain.Keys.accessToken)
        OwlsKeychain.shared.delete(OwlsKeychain.Keys.refreshToken)
        OwlsAnalytics.track(.buttonTapped("Logout", screen: "Profile"))
        OwlsEventBus.shared.post(.userLoggedOut)
    }
}
