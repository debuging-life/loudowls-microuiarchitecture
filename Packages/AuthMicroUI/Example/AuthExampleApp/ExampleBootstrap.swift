import MicroUICore
import AuthMicroUI
import Factory

enum ExampleBootstrap {

    static func run() {
        registerFocusedModule()
        registerCrossModuleStubs()
        registerCoreServices()
    }

    private static func registerFocusedModule() {
        AuthMicroUIConfig().registerMicroUI()
    }

    private static func registerCrossModuleStubs() {
        // Auth Example app does not need stub auth provider — it IS the auth module.
        // But other modules' tile builders may be referenced; provide stubs.
        Container.shared.homeTileBuilder.register {
            OwlsStubTileBuilder(label: "Home Tile")
        }
        Container.shared.profileTileBuilder.register {
            OwlsStubTileBuilder(label: "Profile Tile")
        }
    }

    private static func registerCoreServices() {
        Container.shared.analyticsProviders.register { [] }
    }
}
