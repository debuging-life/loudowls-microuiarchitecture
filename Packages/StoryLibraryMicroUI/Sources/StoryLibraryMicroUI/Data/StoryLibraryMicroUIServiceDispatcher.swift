import Foundation

struct StoryLibraryServiceDispatcher: Sendable {
    let dataSource: StoryLibraryDataSource

    func fetchAll() async throws -> [StoryLibraryItem] {
        try await dataSource.fetchAll()
    }

    func fetchDetail(id: String) async throws -> StoryLibraryItem {
        try await dataSource.fetchDetail(id: id)
    }

    func create(name: String) async throws -> StoryLibraryItem {
        try await dataSource.create(name: name)
    }

    func delete(id: String) async throws {
        try await dataSource.delete(id: id)
    }
}
