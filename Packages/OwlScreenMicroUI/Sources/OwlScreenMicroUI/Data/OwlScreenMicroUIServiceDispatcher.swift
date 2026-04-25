import Foundation

struct OwlScreenServiceDispatcher: Sendable {
    let dataSource: OwlScreenDataSource

    func fetchAll() async throws -> [OwlScreenItem] {
        try await dataSource.fetchAll()
    }

    func fetchDetail(id: String) async throws -> OwlScreenItem {
        try await dataSource.fetchDetail(id: id)
    }

    func create(name: String) async throws -> OwlScreenItem {
        try await dataSource.create(name: name)
    }

    func delete(id: String) async throws {
        try await dataSource.delete(id: id)
    }
}