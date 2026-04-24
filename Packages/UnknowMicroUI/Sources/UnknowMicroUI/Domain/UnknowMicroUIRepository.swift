import Foundation

protocol UnknowRepository: Sendable {
    func loadAll() async throws -> [UnknowItem]
    func loadDetail(id: String) async throws -> UnknowItem
    func create(name: String) async throws -> UnknowItem
    func delete(id: String) async throws
}

struct DefaultUnknowRepository: UnknowRepository {
    private let dispatcher: UnknowServiceDispatcher

    init(dispatcher: UnknowServiceDispatcher) {
        self.dispatcher = dispatcher
    }

    func loadAll() async throws -> [UnknowItem] {
        try await dispatcher.fetchAll()
    }

    func loadDetail(id: String) async throws -> UnknowItem {
        try await dispatcher.fetchDetail(id: id)
    }

    func create(name: String) async throws -> UnknowItem {
        try await dispatcher.create(name: name)
    }

    func delete(id: String) async throws {
        try await dispatcher.delete(id: id)
    }
}