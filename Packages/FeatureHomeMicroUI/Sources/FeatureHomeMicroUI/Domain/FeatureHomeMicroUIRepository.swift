import Foundation

protocol HomeRepository: Sendable {
    func loadItems() async throws -> [HomeItem]
}

struct DefaultHomeRepository: HomeRepository {
    private let dispatcher: HomeServiceDispatcher

    init(dispatcher: HomeServiceDispatcher) {
        self.dispatcher = dispatcher
    }

    func loadItems() async throws -> [HomeItem] {
        try await dispatcher.getItems()
    }
}
