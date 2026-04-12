import Foundation

protocol StoryLibraryRepository: Sendable {
    func loadAll() async throws -> [StoryLibraryItem]
    func loadDetail(id: String) async throws -> StoryLibraryItem
    func create(name: String) async throws -> StoryLibraryItem
    func delete(id: String) async throws
}

struct DefaultStoryLibraryRepository: StoryLibraryRepository {
    private let dispatcher: StoryLibraryServiceDispatcher

    init(dispatcher: StoryLibraryServiceDispatcher) {
        self.dispatcher = dispatcher
    }

    func loadAll() async throws -> [StoryLibraryItem] {
        try await dispatcher.fetchAll()
    }

    func loadDetail(id: String) async throws -> StoryLibraryItem {
        try await dispatcher.fetchDetail(id: id)
    }

    func create(name: String) async throws -> StoryLibraryItem {
        try await dispatcher.create(name: name)
    }

    func delete(id: String) async throws {
        try await dispatcher.delete(id: id)
    }
}
