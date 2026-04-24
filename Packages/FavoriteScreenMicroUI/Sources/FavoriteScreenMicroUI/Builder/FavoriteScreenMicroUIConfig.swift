import MicroUICore
import Factory

public struct FavoriteScreenMicroUIConfig: MicroUIRegistration {

    public init() {}

    public func registerMicroUI() {
        Container.shared.favoritescreenTileBuilder.register {
            FavoriteScreenMicroUITileBuilder()
        }
        Container.shared.favoritescreenScreenBuilder.register {
            FavoriteScreenMicroUIScreenBuilder()
        }

        // Register deep link handler
        OwlsDeepLinkRouter.shared.register(FavoriteScreenMicroUIDeepLinkHandler())
    }
}
