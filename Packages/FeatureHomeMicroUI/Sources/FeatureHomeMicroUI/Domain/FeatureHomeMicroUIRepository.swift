import Foundation

protocol HomeRepository: Sendable {
    func loadStories(page: Int, limit: Int) async throws -> [Story]
    func createStory(title: String, author: String, summary: String) async throws -> Story
    func deleteStory(id: String) async throws
}

struct DefaultHomeRepository: HomeRepository {
    private let dispatcher: HomeServiceDispatcher

    init(dispatcher: HomeServiceDispatcher) {
        self.dispatcher = dispatcher
    }

    func loadStories(page: Int, limit: Int) async throws -> [Story] {
        try await dispatcher.fetchStories(page: page, limit: limit)
    }

    func createStory(title: String, author: String, summary: String) async throws -> Story {
        try await dispatcher.createStory(title: title, author: author, summary: summary)
    }

    func deleteStory(id: String) async throws {
        try await dispatcher.deleteStory(id: id)
    }
}
