import Foundation

protocol TransfersRepository: Sendable {
    func loadData() async throws -> [String]
}

struct DefaultTransfersRepository: TransfersRepository {
    private let dispatcher: TransfersServiceDispatcher

    init(dispatcher: TransfersServiceDispatcher) {
        self.dispatcher = dispatcher
    }

    func loadData() async throws -> [String] {
        try await dispatcher.getData()
    }
}
