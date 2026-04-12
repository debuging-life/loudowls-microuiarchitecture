import Foundation
import MicroUICore

protocol AuthRepository: Sendable {
    func login(username: String, password: String) async throws -> AuthToken
    func refreshToken(_ token: String) async throws -> AuthToken
    func logout(token: String) async throws
}

struct DefaultAuthRepository: AuthRepository {
    private let dispatcher: AuthServiceDispatcher

    init(dispatcher: AuthServiceDispatcher) {
        self.dispatcher = dispatcher
    }

    func login(username: String, password: String) async throws -> AuthToken {
        let credentials = AuthCredentials(username: username, password: password)
        return try await dispatcher.login(credentials: credentials)
    }

    func refreshToken(_ token: String) async throws -> AuthToken {
        try await dispatcher.refreshToken(token)
    }

    func logout(token: String) async throws {
        try await dispatcher.logout(token: token)
    }
}
