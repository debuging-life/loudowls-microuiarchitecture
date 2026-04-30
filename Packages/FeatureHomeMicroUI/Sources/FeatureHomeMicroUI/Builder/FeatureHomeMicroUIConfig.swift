import SwiftUI
import MicroUICore
import Factory

public struct FeatureHomeMicroUIConfig: MicroUIRegistration {

    public init() {}

    public func registerMicroUI() {
        Container.shared.homeScreenBuilder.register {
            FeatureHomeMicroUIScreenBuilder()
        }

        // Register mocks — available in Debug Drawer (DEBUG only)
        #if DEBUG
        OwlsMockRegistry.shared.register(FeatureHomeMicroUIMockProvider())
        #endif
    }

    /// Factory method for Example apps and host apps that want to render
    /// the home module's main screen directly without going through the Container.
    @MainActor
    public static func makeScreen() -> AnyView {
        FeatureHomeMicroUIScreenBuilder().buildScreen()
    }
}
