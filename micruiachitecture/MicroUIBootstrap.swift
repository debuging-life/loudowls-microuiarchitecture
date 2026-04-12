import MicroUICore
import FeatureHomeMicroUI
import FeatureProfileMicroUI
import AboutScreenMicroUI
import TransfersMicroUI
import AuthMicroUI
import StoryLibraryMicroUI

enum MicroUIBootstrap {

    private static let modules: [MicroUIRegistration] = [
        FeatureHomeMicroUIConfig(),
        FeatureProfileMicroUIConfig(),
        AboutScreenMicroUIConfig(),
        TransfersMicroUIConfig(),
        AuthMicroUIConfig(),
        StoryLibraryMicroUIConfig()
    ]

    static func register() {
        registerFeatureFlags()
        modules.forEach { $0.registerMicroUI() }
        registerLocalization()
        registerAnalytics()
    }

    private static func registerFeatureFlags() {
        let provider = DefaultFeatureFlagProvider()
        Container.shared.featureFlagProvider.register { provider }
        // Fetch latest flags from server (non-blocking)
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
            // Production: [FirebaseAnalyticsProvider(), MixpanelAnalyticsProvider()]
        }
    }
}
