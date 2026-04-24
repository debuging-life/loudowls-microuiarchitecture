import MicroUICore
import Factory

public struct UnknowMicroUIConfig: MicroUIRegistration {

    public init() {}

    public func registerMicroUI() {
        Container.shared.unknowTileBuilder.register {
            UnknowMicroUITileBuilder()
        }
        Container.shared.unknowScreenBuilder.register {
            UnknowMicroUIScreenBuilder()
        }

        // Register deep link handler
        OwlsDeepLinkRouter.shared.register(UnknowMicroUIDeepLinkHandler())
    }
}
