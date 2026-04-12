import Foundation

public protocol AuthTokenProvider: Sendable {
    func token() async throws -> String
    func refreshToken() async throws -> String
    var isAuthenticated: Bool { get }
}
