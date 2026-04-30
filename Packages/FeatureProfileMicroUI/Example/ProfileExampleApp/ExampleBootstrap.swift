import MicroUICore
import FeatureProfileMicroUI
import Factory

enum ExampleBootstrap {

    static func run() {
        registerFocusedModule()
        registerCrossModuleStubs()
        registerCoreServices()
    }

    private static func registerFocusedModule() {
        FeatureProfileMicroUIConfig().registerMicroUI()
    }

    private static func registerCrossModuleStubs() {
        Container.shared.authTokenProvider.register {
            OwlsStubAuthTokenProvider()
        }
        Container.shared.homeTileBuilder.register {
            OwlsStubTileBuilder(label: "Home Tile")
        }
        Container.shared.authTileBuilder.register {
            OwlsStubTileBuilder(label: "Auth Tile")
        }
    }

    private static func registerCoreServices() {
        Container.shared.analyticsProviders.register { [] }
    }
}
