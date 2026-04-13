import Foundation
import Observation
import MicroUICore
import Factory

@Observable
final class AuthMicroUIViewModel {

    // MARK: - State

    var username = ""
    var password = ""
    var signupName = ""
    var signupEmail = ""
    var signupPassword = ""
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var isLoggedIn = false

    // MARK: - Dependencies

    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    // MARK: - Login

    func login() async {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter username and password"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let token = try await repository.login(username: username, password: password)
            let provider = LiveAuthTokenProvider(token: token, repository: repository)
            Container.shared.authTokenProvider.register { provider }

            // Persist token to Keychain
            OwlsKeychain.shared.save(token.accessToken, forKey: OwlsKeychain.Keys.accessToken)
            OwlsKeychain.shared.save(token.refreshToken, forKey: OwlsKeychain.Keys.refreshToken)

            isLoggedIn = true
            OwlsAnalytics.track(.buttonTapped("Sign In", screen: "Auth"))
            OwlsEventBus.shared.post(.userLoggedIn)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Signup

    func signup() async {
        guard !signupName.isEmpty, !signupEmail.isEmpty, !signupPassword.isEmpty else {
            errorMessage = "Please fill all fields"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let token = try await repository.login(username: signupEmail, password: signupPassword)
            let provider = LiveAuthTokenProvider(token: token, repository: repository)
            Container.shared.authTokenProvider.register { provider }

            OwlsKeychain.shared.save(token.accessToken, forKey: OwlsKeychain.Keys.accessToken)
            OwlsKeychain.shared.save(token.refreshToken, forKey: OwlsKeychain.Keys.refreshToken)

            isLoggedIn = true
            OwlsAnalytics.track(.buttonTapped("Sign Up", screen: "Auth"))
            OwlsEventBus.shared.post(.userLoggedIn)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

// MARK: - Live Token Provider

final class LiveAuthTokenProvider: AuthTokenProvider, @unchecked Sendable {

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
        OwlsEventBus.shared.post(.tokenRefreshed)
        return newToken.accessToken
    }
}
