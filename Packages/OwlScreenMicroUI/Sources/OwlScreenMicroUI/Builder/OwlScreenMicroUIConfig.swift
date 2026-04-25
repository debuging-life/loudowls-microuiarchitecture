import MicroUICore
import Factory

public struct OwlScreenMicroUIConfig: MicroUIRegistration {

    public init() {}

    public func registerMicroUI() {
        Container.shared.owlscreenTileBuilder.register {
            OwlScreenMicroUITileBuilder()
        }
        Container.shared.owlscreenScreenBuilder.register {
            OwlScreenMicroUIScreenBuilder()
        }

        // Register deep link handler
        OwlsDeepLinkRouter.shared.register(OwlScreenMicroUIDeepLinkHandler())

        // Register mock provider — available in Debug Drawer (DEBUG only)
        #if DEBUG
        OwlsMockRegistry.shared.register(OwlScreenMicroUIMockProvider())
        #endif
    }
}