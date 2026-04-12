import Foundation

protocol ProfileRepository: Sendable {
    func loadProfile() async throws -> UserProfile
    func saveProfile(_ profile: UserProfile) async throws -> UserProfile
}

struct DefaultProfileRepository: ProfileRepository {
    private let dispatcher: ProfileServiceDispatcher

    init(dispatcher: ProfileServiceDispatcher) {
        self.dispatcher = dispatcher
    }

    func loadProfile() async throws -> UserProfile {
        try await dispatcher.getProfile()
    }

    func saveProfile(_ profile: UserProfile) async throws -> UserProfile {
        try await dispatcher.saveProfile(profile)
    }
}
