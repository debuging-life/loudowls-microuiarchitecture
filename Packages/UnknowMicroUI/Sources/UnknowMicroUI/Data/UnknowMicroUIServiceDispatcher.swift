import Foundation

struct UnknowServiceDispatcher: Sendable {
    let dataSource: UnknowDataSource

    func fetchAll() async throws -> [UnknowItem] {
        try await dataSource.fetchAll()
    }

    func fetchDetail(id: String) async throws -> UnknowItem {
        try await dataSource.fetchDetail(id: id)
    }

    func create(name: String) async throws -> UnknowItem {
        try await dataSource.create(name: name)
    }

    func delete(id: String) async throws {
        try await dataSource.delete(id: id)
    }
}