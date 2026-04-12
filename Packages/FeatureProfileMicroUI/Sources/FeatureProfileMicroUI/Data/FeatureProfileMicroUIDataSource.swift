import Foundation

protocol ProfileDataSource: Sendable {
    func fetchProfile() async throws -> UserProfile
    func updateProfile(_ profile: UserProfile) async throws -> UserProfile
}

struct MockProfileDataSource: ProfileDataSource {
    func fetchProfile() async throws -> UserProfile {
        try await Task.sleep(for: .milliseconds(300))
        return UserProfile.mock
    }

    func updateProfile(_ profile: UserProfile) async throws -> UserProfile {
        try await Task.sleep(for: .milliseconds(500))
        return profile
    }
}
