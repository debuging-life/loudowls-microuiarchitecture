import Foundation

struct OwlAboutServiceDispatcher: Sendable {
    let dataSource: OwlAboutDataSource

    func fetchAll() async throws -> [OwlAboutItem] {
        try await dataSource.fetchAll()
    }

    func fetchDetail(id: String) async throws -> OwlAboutItem {
        try await dataSource.fetchDetail(id: id)
    }

    func create(name: String) async throws -> OwlAboutItem {
        try await dataSource.create(name: name)
    }

    func delete(id: String) async throws {
        try await dataSource.delete(id: id)
    }
}