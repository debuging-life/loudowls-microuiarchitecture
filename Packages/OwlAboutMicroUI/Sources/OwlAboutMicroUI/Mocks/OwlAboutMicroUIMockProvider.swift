import Foundation
import MicroUICore

// MARK: - Mock Provider
//
// Lists all mock JSON responses available for this module.
// Endpoint + method come from OwlAboutAPI — single source of truth.
// Appears in the Debug Drawer (DEBUG builds only).
//
// To add a new mock:
//   1. Add a JSON file in Mocks/JSON/
//   2. Append an OwlsMockItem below referencing the route case

public struct OwlAboutMicroUIMockProvider: OwlsMockProvider {

    public var moduleName: String { "OwlAboutMicroUI" }

    public init() {}

    public func mockItems() -> [OwlsMockItem] {
        // Reference the API route — endpoint/method come from OwlAboutAPI
        let listRoute = OwlAboutAPI.list

        return [
            OwlsMockItem(
                id: "owlabout.list.success",
                name: "OwlAbout — Success (3 items)",
                module: moduleName,
                route: listRoute,
                jsonFilename: "owlaboutSuccess.json",
                bundle: .module,
                statusCode: 200,
                category: .success
            ),
            OwlsMockItem(
                id: "owlabout.list.empty",
                name: "OwlAbout — Empty",
                module: moduleName,
                route: listRoute,
                jsonFilename: "owlaboutEmpty.json",
                bundle: .module,
                statusCode: 200,
                category: .empty
            ),
            OwlsMockItem(
                id: "owlabout.list.failure",
                name: "OwlAbout — 500 Server Error",
                module: moduleName,
                route: listRoute,
                jsonFilename: "owlaboutFailure.json",
                bundle: .module,
                statusCode: 500,
                category: .failure
            ),
        ]
    }
}