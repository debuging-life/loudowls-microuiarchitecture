import MicroUICore
import FeatureHomeMicroUI
import Factory

// To use REAL modules instead of stubs, add their packages to this xcodeproj
// then uncomment the matching imports + registrations below.
//
// import FeatureProfileMicroUI
// import AuthMicroUI

enum ExampleBootstrap {

    static func run() {
        registerFocusedModule()
        registerCrossModuleStubs()
        registerCoreServices()
        enableDefaultMocks()
    }

    // MARK: - Step 1: Register the focused module

    private static func registerFocusedModule() {
        FeatureHomeMicroUIConfig().registerMicroUI()
    }

    // MARK: - Step 2: Stub cross-module DI slots

    private static func registerCrossModuleStubs() {
        // Auth token — so OwlsBaseService works
        Container.shared.authTokenProvider.register {
            OwlsStubAuthTokenProvider()
        }

        // Stubs for tile builders this module may embed.
        // Comment out + replace with real config to test integration.
        Container.shared.profileTileBuilder.register {
            OwlsStubTileBuilder(label: "Profile Tile")
        }
        Container.shared.authTileBuilder.register {
            OwlsStubTileBuilder(label: "Auth Tile")
        }
        Container.shared.settingsTileBuilder.register {
            OwlsStubTileBuilder(label: "Settings Tile")
        }

        // Real-module integration example:
        // FeatureProfileMicroUIConfig().registerMicroUI()
    }

    // MARK: - Step 3: Core services

    private static func registerCoreServices() {
        Container.shared.analyticsProviders.register { [] }
    }

    // MARK: - Step 4: Pre-enable success mocks

    private static func enableDefaultMocks() {
        #if DEBUG
        OwlsMockRegistry.shared.setEnabled("home.stories.success", enabled: true)
        #endif
    }
}
