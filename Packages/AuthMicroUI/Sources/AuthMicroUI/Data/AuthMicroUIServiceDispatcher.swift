import Foundation

struct AuthServiceDispatcher: Sendable {
    let dataSource: AuthDataSource

    func login(credentials: AuthCredentials) async throws -> AuthToken {
        try await dataSource.login(credentials: credentials)
    }

    func refreshToken(_ token: String) async throws -> AuthToken {
        try await dataSource.refreshToken(token)
    }

    func logout(token: String) async throws {
        try await dataSource.logout(token: token)
    }
}
