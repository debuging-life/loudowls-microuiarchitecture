import Foundation

struct AuthCredentials: Sendable {
    let username: String
    let password: String
}

struct AuthToken: Sendable, Codable {
    let accessToken: String
    let refreshToken: String
    let expiresAt: Date

    var isExpired: Bool { Date() >= expiresAt }

    static func mock(for username: String) -> AuthToken {
        AuthToken(
            accessToken: "access_\(username)_\(UUID().uuidString.prefix(8))",
            refreshToken: "refresh_\(username)_\(UUID().uuidString.prefix(8))",
            expiresAt: Date().addingTimeInterval(3600)
        )
    }
}

struct AuthUser: Sendable, Identifiable {
    let id: String
    let username: String
    let displayName: String
    let lastLogin: Date
}
