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
}
