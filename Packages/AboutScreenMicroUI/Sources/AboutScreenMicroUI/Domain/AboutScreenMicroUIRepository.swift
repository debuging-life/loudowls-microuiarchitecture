import Foundation

protocol AboutScreenRepository: Sendable {
    func loadData() async throws -> [String]
}

struct DefaultAboutScreenRepository: AboutScreenRepository {
    private let dispatcher: AboutScreenServiceDispatcher

    init(dispatcher: AboutScreenServiceDispatcher) {
        self.dispatcher = dispatcher
    }

    func loadData() async throws -> [String] {
        try await dispatcher.getData()
    }
}
