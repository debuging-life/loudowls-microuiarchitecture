import Foundation
import Observation

@Observable
final class ProfileViewModel {

    // MARK: - State

    private(set) var profile: UserProfile?
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    // MARK: - Dependencies

    private let repository: ProfileRepository

    init(repository: ProfileRepository) {
        self.repository = repository
    }

    // MARK: - Actions

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
}
