import Foundation
import MicroUICore
import Factory

// MARK: - Deep Link Handler
//
// Handles URLs like: owlsapp://unknow/detail/123
//
// Registered in Config.swift via:
//   OwlsDeepLinkRouter.shared.register(UnknowMicroUIDeepLinkHandler())

struct UnknowMicroUIDeepLinkHandler: OwlsDeepLinkHandler {

    var supportedModules: [String] { ["unknow"] }

    func handle(_ deepLink: OwlsDeepLink) -> Bool {
        let coordinator = Container.shared.unknowNavigationCoordinator()

        // Parse the path: "unknow/detail/123"
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