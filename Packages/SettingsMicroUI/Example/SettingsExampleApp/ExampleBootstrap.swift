import MicroUICore
import SettingsMicroUI
import Factory

enum ExampleBootstrap {

    static func run() {
        registerFocusedModule()
        registerCrossModuleStubs()
        registerCoreServices()
    }

    private static func registerFocusedModule() {
        SettingsMicroUIConfig().registerMicroUI()
    }

    private static func registerCrossModuleStubs() {
        Container.shared.authTokenProvider.register {
            OwlsStubAuthTokenProvider()
        }
    }

    private static func registerCoreServices() {
        Container.shared.analyticsProviders.register { [] }

        // Settings reads from a language provider — use a minimal stub
        Container.shared.languageProvider.register { nil }
    }
}
