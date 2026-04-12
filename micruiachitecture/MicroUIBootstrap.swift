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
        modules.forEach { $0.registerMicroUI() }
        registerLocalization()
    }

    private static func registerLocalization() {
        Container.shared.languageProvider.register {
            DefaultLanguageProvider()
        }
    }
}
