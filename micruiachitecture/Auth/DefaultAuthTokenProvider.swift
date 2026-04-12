import Foundation
import MicroUICore

struct DefaultAuthTokenProvider: AuthTokenProvider {

    // MARK: - State

    private let storage = TokenStorage()

    var isAuthenticated: Bool {
        storage.accessToken != nil
    }

    // MARK: - AuthTokenProvider

    func token() async throws -> String {
        guard let token = storage.accessToken else {
            throw AuthError.notAuthenticated
        }
        return token
    }

    func refreshToken() async throws -> String {
        // TODO: Replace with real refresh endpoint call
        try await Task.sleep(for: .milliseconds(500))
        let newToken = "refreshed_token_\(UUID().uuidString)"
        storage.accessToken = newToken
        return newToken
    }
}

// MARK: - Token Storage

private final class TokenStorage: @unchecked Sendable {
    nonisolated(unsafe) var accessToken: String? = "mock_access_token_12345"
}

// MARK: - Error

enum AuthError: LocalizedError {
    case notAuthenticated
    case tokenExpired
    case refreshFailed

    var errorDescription: String? {
        switch self {
        case .notAuthenticated: "User is not authenticated"
        case .tokenExpired: "Token has expired"
        case .refreshFailed: "Failed to refresh token"
        }
    }
}
