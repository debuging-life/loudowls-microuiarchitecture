import MicroUICore
import FeatureHomeMicroUI
import FeatureProfileMicroUI
import AuthMicroUI

enum MicroUIBootstrap {

    private static let modules: [MicroUIRegistration] = [
        FeatureHomeMicroUIConfig(),
        FeatureProfileMicroUIConfig(),
        AuthMicroUIConfig()
    ]

    static func register() {
        registerFeatureFlags()
        modules.forEach { $0.registerMicroUI() }
        registerLocalization()
        registerAnalytics()
        restoreSession()
    }

    private static func registerFeatureFlags() {
        let provider = DefaultFeatureFlagProvider()
        Container.shared.featureFlagProvider.register { provider }
        Task { try? await provider.fetchFlags() }
    }

    private static func registerLocalization() {
        Container.shared.languageProvider.register {
            DefaultLanguageProvider()
        }
    }

    private static func registerAnalytics() {
        Container.shared.analyticsProviders.register {
            [ConsoleAnalyticsProvider()]
        }
    }

    // MARK: - Restore Session from Keychain

    private static func restoreSession() {
        guard let accessToken = OwlsKeychain.shared.string(forKey: OwlsKeychain.Keys.accessToken),
              let refreshToken = OwlsKeychain.shared.string(forKey: OwlsKeychain.Keys.refreshToken) else {
            return
        }

        let token = KeychainRestoredTokenProvider(accessToken: accessToken, refreshToken: refreshToken)
        Container.shared.authTokenProvider.register { token }
    }
}

// MARK: - Restored Token Provider

private final class KeychainRestoredTokenProvider: AuthTokenProvider, @unchecked Sendable {
    private var accessToken: String
    private let refreshToken: String

    init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    var isAuthenticated: Bool { true }

    func token() async throws -> String {
        accessToken
    }

    func refreshToken() async throws -> String {
        // In production: call refresh API, update keychain
        accessToken
    }
}
