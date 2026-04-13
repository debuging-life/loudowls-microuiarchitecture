import Foundation

protocol HomeRepository: Sendable {
    func loadStories() async throws -> [Story]
    func createStory(title: String, author: String, summary: String) async throws -> Story
    func deleteStory(id: String) async throws
}

struct DefaultHomeRepository: HomeRepository {
    private let dispatcher: HomeServiceDispatcher

    init(dispatcher: HomeServiceDispatcher) {
        self.dispatcher = dispatcher
    }

    func loadStories() async throws -> [Story] {
        try await dispatcher.fetchStories()
    }

    func createStory(title: String, author: String, summary: String) async throws -> Story {
        try await dispatcher.createStory(title: title, author: author, summary: summary)
    }

    func deleteStory(id: String) async throws {
        try await dispatcher.deleteStory(id: id)
    }
}
