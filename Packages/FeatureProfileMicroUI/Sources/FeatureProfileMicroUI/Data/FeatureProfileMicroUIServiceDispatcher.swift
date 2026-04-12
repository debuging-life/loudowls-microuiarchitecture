import Foundation

struct ProfileServiceDispatcher: Sendable {
    let dataSource: ProfileDataSource

    func getProfile() async throws -> UserProfile {
        try await dataSource.fetchProfile()
    }

    func saveProfile(_ profile: UserProfile) async throws -> UserProfile {
        try await dataSource.updateProfile(profile)
    }
}
