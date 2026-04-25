import Foundation
import MicroUICore

// MARK: - Mock Provider
//
// Lists all mock JSON responses available for this module.
// Endpoint + method come from FavoriteScreenAPI — single source of truth.
// Appears in the Debug Drawer (DEBUG builds only).

public struct FavoriteScreenMicroUIMockProvider: OwlsMockProvider {

    public var moduleName: String { "FavoriteScreenMicroUI" }

    public init() {}

    public func mockItems() -> [OwlsMockItem] {
        let listRoute = FavoriteScreenAPI.list

        return [
            OwlsMockItem(
                id: "favoritescreen.list.success",
                name: "FavoriteScreen — Success (3 items)",
                module: moduleName,
                route: listRoute,
                jsonFilename: "favoritescreenSuccess.json",
                bundle: .module,
                statusCode: 200,
                category: .success
            ),
            OwlsMockItem(
                id: "favoritescreen.list.empty",
                name: "FavoriteScreen — Empty",
                module: moduleName,
                route: listRoute,
                jsonFilename: "favoritescreenEmpty.json",
                bundle: .module,
                statusCode: 200,
                category: .empty
            ),
            OwlsMockItem(
                id: "favoritescreen.list.failure",
                name: "FavoriteScreen — 500 Server Error",
                module: moduleName,
                route: listRoute,
                jsonFilename: "favoritescreenFailure.json",
                bundle: .module,
                statusCode: 500,
                category: .failure
            ),
        ]
    }
}
