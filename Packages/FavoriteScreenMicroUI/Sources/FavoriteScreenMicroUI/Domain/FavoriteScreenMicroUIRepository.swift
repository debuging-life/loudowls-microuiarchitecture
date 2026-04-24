import Foundation

protocol FavoriteScreenRepository: Sendable {
    func loadAll() async throws -> [FavoriteScreenItem]
    func loadDetail(id: String) async throws -> FavoriteScreenItem
    func create(name: String) async throws -> FavoriteScreenItem
    func delete(id: String) async throws
}

struct DefaultFavoriteScreenRepository: FavoriteScreenRepository {
    private let dispatcher: FavoriteScreenServiceDispatcher

    init(dispatcher: FavoriteScreenServiceDispatcher) {
        self.dispatcher = dispatcher
    }

    func loadAll() async throws -> [FavoriteScreenItem] {
        try await dispatcher.fetchAll()
    }

    func loadDetail(id: String) async throws -> FavoriteScreenItem {
        try await dispatcher.fetchDetail(id: id)
    }

    func create(name: String) async throws -> FavoriteScreenItem {
        try await dispatcher.create(name: name)
    }

    func delete(id: String) async throws {
        try await dispatcher.delete(id: id)
    }
}