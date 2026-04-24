import Foundation

struct FavoriteScreenServiceDispatcher: Sendable {
    let dataSource: FavoriteScreenDataSource

    func fetchAll() async throws -> [FavoriteScreenItem] {
        try await dataSource.fetchAll()
    }

    func fetchDetail(id: String) async throws -> FavoriteScreenItem {
        try await dataSource.fetchDetail(id: id)
    }

    func create(name: String) async throws -> FavoriteScreenItem {
        try await dataSource.create(name: name)
    }

    func delete(id: String) async throws {
        try await dataSource.delete(id: id)
    }
}