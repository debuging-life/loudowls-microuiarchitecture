import MicroUICore
import Factory

public struct OwlAboutMicroUIConfig: MicroUIRegistration {

    public init() {}

    public func registerMicroUI() {
        Container.shared.owlaboutTileBuilder.register {
            OwlAboutMicroUITileBuilder()
        }
        Container.shared.owlaboutScreenBuilder.register {
            OwlAboutMicroUIScreenBuilder()
        }

        // Register deep link handler
        OwlsDeepLinkRouter.shared.register(OwlAboutMicroUIDeepLinkHandler())

        // Register mock provider — available in Debug Drawer (DEBUG only)
        #if DEBUG
        OwlsMockRegistry.shared.register(OwlAboutMicroUIMockProvider())
        #endif
    }
}