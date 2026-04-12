import Foundation

protocol AuthDataSource: Sendable {
    func login(credentials: AuthCredentials) async throws -> AuthToken
    func refreshToken(_ token: String) async throws -> AuthToken
    func logout(token: String) async throws
}

struct MockAuthDataSource: AuthDataSource {

    func login(credentials: AuthCredentials) async throws -> AuthToken {
        try await Task.sleep(for: .seconds(1))

        guard credentials.username.count >= 3, credentials.password.count >= 4 else {
            throw AuthServiceError.invalidCredentials
        }

        return AuthToken.mock(for: credentials.username)
    }

    func refreshToken(_ token: String) async throws -> AuthToken {
        try await Task.sleep(for: .milliseconds(500))

        guard token.hasPrefix("refresh_") else {
            throw AuthServiceError.refreshFailed
        }

        return AuthToken(
            accessToken: "access_refreshed_\(UUID().uuidString.prefix(8))",
            refreshToken: token,
            expiresAt: Date().addingTimeInterval(3600)
        )
    }

    func logout(token: String) async throws {
        try await Task.sleep(for: .milliseconds(300))
    }
}

// MARK: - Errors

enum AuthServiceError: LocalizedError {
    case invalidCredentials
    case refreshFailed
    case networkError

    var errorDescription: String? {
        switch self {
        case .invalidCredentials: "Invalid username or password"
        case .refreshFailed: "Session expired. Please sign in again."
        case .networkError: "Network error. Please try again."
        }
    }
}
