import Foundation
import MicroUICore
import Factory

// MARK: - Deep Link Handler
//
// Handles URLs like: owlsapp://favoritescreen/detail/123
//
// Registered in Config.swift via:
//   OwlsDeepLinkRouter.shared.register(FavoriteScreenMicroUIDeepLinkHandler())

struct FavoriteScreenMicroUIDeepLinkHandler: OwlsDeepLinkHandler {

    var supportedModules: [String] { ["favoritescreen"] }

    func handle(_ deepLink: OwlsDeepLink) -> Bool {
        let coordinator = Container.shared.favoritescreenNavigationCoordinator()

        // Parse the path: "favoritescreen/detail/123"
        let components = deepLink.path.split(separator: "/")

        if components.first == "detail", let id = components.dropFirst().first {
            // Pass data to coordinator and present
            coordinator.present(style: .fullScreen, data: ["itemId": String(id)])
            return true
        }

        // Default: just open the module
        coordinator.present(style: .fullScreen)
        return true
    }
}