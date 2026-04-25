import Foundation
import MicroUICore

// MARK: - Mock Provider
//
// Lists all mock JSON responses available for this module.
// Endpoint + method come from HomeAPI — single source of truth.

public struct FeatureHomeMicroUIMockProvider: OwlsMockProvider {

    public var moduleName: String { "FeatureHomeMicroUI" }

    public init() {}

    public func mockItems() -> [OwlsMockItem] {
        // Reference the API route — endpoint/method come from HomeAPI.list
        let listRoute = HomeAPI.list(page: 1, limit: 1)

        return [
            OwlsMockItem(
                id: "home.stories.success",
                name: "Stories — Success (3 items)",
                module: moduleName,
                route: listRoute,
                jsonFilename: "storiesSuccess.json",
                bundle: .module,
                statusCode: 200,
                category: .success
            ),
            OwlsMockItem(
                id: "home.stories.empty",
                name: "Stories — Empty",
                module: moduleName,
                route: listRoute,
                jsonFilename: "storiesEmpty.json",
                bundle: .module,
                statusCode: 200,
                category: .empty
            ),
            OwlsMockItem(
                id: "home.stories.failure",
                name: "Stories — 500 Server Error",
                module: moduleName,
                route: listRoute,
                jsonFilename: "storiesFailure.json",
                bundle: .module,
                statusCode: 500,
                category: .failure
            ),
        ]
    }
}
