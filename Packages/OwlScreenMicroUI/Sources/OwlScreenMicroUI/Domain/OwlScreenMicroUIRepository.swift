import Foundation

protocol OwlScreenRepository: Sendable {
    func loadAll() async throws -> [OwlScreenItem]
    func loadDetail(id: String) async throws -> OwlScreenItem
    func create(name: String) async throws -> OwlScreenItem
    func delete(id: String) async throws
}

struct DefaultOwlScreenRepository: OwlScreenRepository {
    private let dispatcher: OwlScreenServiceDispatcher

    init(dispatcher: OwlScreenServiceDispatcher) {
        self.dispatcher = dispatcher
    }

    func loadAll() async throws -> [OwlScreenItem] {
        try await dispatcher.fetchAll()
    }

    func loadDetail(id: String) async throws -> OwlScreenItem {
        try await dispatcher.fetchDetail(id: id)
    }

    func create(name: String) async throws -> OwlScreenItem {
        try await dispatcher.create(name: name)
    }

    func delete(id: String) async throws {
        try await dispatcher.delete(id: id)
    }
}