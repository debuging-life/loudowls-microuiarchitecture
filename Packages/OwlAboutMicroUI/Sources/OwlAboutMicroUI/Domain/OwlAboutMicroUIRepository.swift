import Foundation

protocol OwlAboutRepository: Sendable {
    func loadAll() async throws -> [OwlAboutItem]
    func loadDetail(id: String) async throws -> OwlAboutItem
    func create(name: String) async throws -> OwlAboutItem
    func delete(id: String) async throws
}

struct DefaultOwlAboutRepository: OwlAboutRepository {
    private let dispatcher: OwlAboutServiceDispatcher

    init(dispatcher: OwlAboutServiceDispatcher) {
        self.dispatcher = dispatcher
    }

    func loadAll() async throws -> [OwlAboutItem] {
        try await dispatcher.fetchAll()
    }

    func loadDetail(id: String) async throws -> OwlAboutItem {
        try await dispatcher.fetchDetail(id: id)
    }

    func create(name: String) async throws -> OwlAboutItem {
        try await dispatcher.create(name: name)
    }

    func delete(id: String) async throws {
        try await dispatcher.delete(id: id)
    }
}