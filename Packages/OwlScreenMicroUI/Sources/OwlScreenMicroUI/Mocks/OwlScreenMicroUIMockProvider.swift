import Foundation
import MicroUICore

// MARK: - Mock Provider
//
// Lists all mock JSON responses available for this module.
// Endpoint + method come from OwlScreenAPI — single source of truth.
// Appears in the Debug Drawer (DEBUG builds only).

public struct OwlScreenMicroUIMockProvider: OwlsMockProvider {

    public var moduleName: String { "OwlScreenMicroUI" }

    public init() {}

    public func mockItems() -> [OwlsMockItem] {
        let listRoute = OwlScreenAPI.list

        return [
            OwlsMockItem(
                id: "owlscreen.list.success",
                name: "OwlScreen — Success (3 items)",
                module: moduleName,
                route: listRoute,
                jsonFilename: "owlscreenSuccess.json",
                bundle: .module,
                statusCode: 200,
                category: .success
            ),
            OwlsMockItem(
                id: "owlscreen.list.empty",
                name: "OwlScreen — Empty",
                module: moduleName,
                route: listRoute,
                jsonFilename: "owlscreenEmpty.json",
                bundle: .module,
                statusCode: 200,
                category: .empty
            ),
            OwlsMockItem(
                id: "owlscreen.list.failure",
                name: "OwlScreen — 500 Server Error",
                module: moduleName,
                route: listRoute,
                jsonFilename: "owlscreenFailure.json",
                bundle: .module,
                statusCode: 500,
                category: .failure
            ),
        ]
    }
}
