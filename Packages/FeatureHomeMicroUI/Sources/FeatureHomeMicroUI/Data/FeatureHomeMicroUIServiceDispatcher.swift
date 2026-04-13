import Foundation

struct HomeServiceDispatcher: Sendable {
    let dataSource: HomeDataSource

    func fetchStories(page: Int, limit: Int) async throws -> [Story] {
        try await dataSource.fetchStories(page: page, limit: limit)
    }

    func createStory(title: String, author: String, summary: String) async throws -> Story {
        try await dataSource.createStory(title: title, author: author, summary: summary)
    }

    func deleteStory(id: String) async throws {
        try await dataSource.deleteStory(id: id)
    }
}
