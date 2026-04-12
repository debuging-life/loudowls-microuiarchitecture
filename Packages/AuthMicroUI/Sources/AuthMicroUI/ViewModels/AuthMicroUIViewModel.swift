import Foundation
import Observation
import MicroUICore
import Factory

@Observable
final class AuthMicroUIViewModel {

    // MARK: - State

    var username = ""
    var password = ""
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var currentToken: AuthToken?
    private(set) var isLoggedIn = false

    // MARK: - Dependencies

    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    // MARK: - Actions

    func login() async {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter username and password"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let token = try await repository.login(username: username, password: password)
            currentToken = token
            isLoggedIn = true

            // Register the live token provider into the shared container
            let provider = LiveAuthTokenProvider(token: token, repository: repository)
            Container.shared.authTokenProvider.register { provider }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func logout() async {
        isLoading = true

        if let token = currentToken {
            try? await repository.logout(token: token.accessToken)
        }

        currentToken = nil
        isLoggedIn = false
        username = ""
        password = ""

        // Clear the token provider
        Container.shared.authTokenProvider.register { nil }

        isLoading = false
    }

    func refreshToken() async {
        guard let token = currentToken else { return }

        isLoading = true
        errorMessage = nil

        do {
            let newToken = try await repository.refreshToken(token.refreshToken)
            currentToken = newToken

            let provider = LiveAuthTokenProvider(token: newToken, repository: repository)
            Container.shared.authTokenProvider.register { provider }
        } catch {
            errorMessage = error.localizedDescription
            // Force logout on refresh failure
            await logout()
        }

        isLoading = false
    }
}

// MARK: - Live Token Provider

private final class LiveAuthTokenProvider: AuthTokenProvider, @unchecked Sendable {

    private var currentToken: AuthToken
    private let repository: AuthRepository

    init(token: AuthToken, repository: AuthRepository) {
        self.currentToken = token
        self.repository = repository
    }

    var isAuthenticated: Bool { !currentToken.isExpired }

    func token() async throws -> String {
        if currentToken.isExpired {
            return try await refreshToken()
        }
        return currentToken.accessToken
    }

    func refreshToken() async throws -> String {
        let newToken = try await repository.refreshToken(currentToken.refreshToken)
        currentToken = newToken
        return newToken.accessToken
    }
}
