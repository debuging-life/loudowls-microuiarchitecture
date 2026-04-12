import Foundation
import Observation

@Observable
final class EditProfileViewModel {

    // MARK: - State

    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    private(set) var isSaving = false
    private(set) var errorMessage: String?

    // MARK: - Dependencies

    private let original: UserProfile
    private let repository: ProfileRepository

    init(profile: UserProfile, repository: ProfileRepository) {
        self.original = profile
        self.firstName = profile.firstName
        self.lastName = profile.lastName
        self.email = profile.email
        self.phone = profile.phone
        self.repository = repository
    }

    // MARK: - Actions

    var hasChanges: Bool {
        firstName != original.firstName
        || lastName != original.lastName
        || email != original.email
        || phone != original.phone
    }

    func save() async -> Bool {
        isSaving = true
        errorMessage = nil
        var updated = original
        updated.firstName = firstName
        updated.lastName = lastName
        updated.email = email
        updated.phone = phone
        do {
            _ = try await repository.saveProfile(updated)
            isSaving = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isSaving = false
            return false
        }
    }
}
