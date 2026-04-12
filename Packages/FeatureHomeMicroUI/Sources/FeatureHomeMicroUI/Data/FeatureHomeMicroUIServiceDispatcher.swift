import Foundation

struct HomeServiceDispatcher: Sendable {
    let dataSource: HomeDataSource

    func getItems() async throws -> [HomeItem] {
        try await dataSource.fetchItems()
    }
}
