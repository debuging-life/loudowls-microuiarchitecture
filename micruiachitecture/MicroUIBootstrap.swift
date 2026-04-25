import Foundation
import MicroUICore
import FeatureHomeMicroUI
import FeatureProfileMicroUI
import AuthMicroUI
import OnboardingMicroUI
import SettingsMicroUI
import FavoriteScreenMicroUI
import OwlScreenMicroUI
import OwlAboutMicroUI

enum MicroUIBootstrap {

    private static let modules: [MicroUIRegistration] = [
        FeatureHomeMicroUIConfig(),
        FeatureProfileMicroUIConfig(),
        AuthMicroUIConfig(),
        OnboardingMicroUIConfig(),
        SettingsMicroUIConfig(),
        FavoriteScreenMicroUIConfig(),
        OwlScreenMicroUIConfig(),
        OwlAboutMicroUIConfig()
    ]

    static func register() {
        registerFeatureFlags()
        modules.forEach { $0.registerMicroUI() }
        registerLocalization()
        registerAnalytics()
        restoreSession()
        enableDefaultMocksIfNeeded()
    }

    /// On first launch in DEBUG, enable success mocks so the demo
    /// works out of the box without a real backend.
    private static func enableDefaultMocksIfNeeded() {
        #if DEBUG
        let key = "owls.mocks.defaultsEnabled"
        guard !UserDefaults.standard.bool(forKey: key) else { return }

        OwlsMockRegistry.shared.setEnabled("home.stories.success", enabled: true)
        UserDefaults.standard.set(true, forKey: key)
        #endif
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

    private static func restoreSession() {
        guard let accessToken = OwlsKeychain.shared.string(forKey: OwlsKeychain.Keys.accessToken),
              let refreshToken = OwlsKeychain.shared.string(forKey: OwlsKeychain.Keys.refreshToken) else {
            return
        }

        let token = KeychainRestoredTokenProvider(accessToken: accessToken, refreshToken: refreshToken)
        Container.shared.authTokenProvider.register { token }
    }
}

private final class KeychainRestoredTokenProvider: AuthTokenProvider, @unchecked Sendable {
    private var accessToken: String
    private let refreshToken: String

    init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    var isAuthenticated: Bool { true }

    func token() async throws -> String { accessToken }
    func refreshToken() async throws -> String { accessToken }
}
