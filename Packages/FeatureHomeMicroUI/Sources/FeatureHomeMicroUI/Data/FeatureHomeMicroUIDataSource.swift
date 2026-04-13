import Foundation
import MicroUICore

protocol HomeDataSource: Sendable {
    func fetchStories() async throws -> [Story]
    func createStory(title: String, author: String, summary: String) async throws -> Story
    func deleteStory(id: String) async throws
}

// MARK: - Mock

struct MockHomeDataSource: HomeDataSource {
    func fetchStories() async throws -> [Story] {
        try await Task.sleep(for: .milliseconds(500))
        return Story.mock
    }

    func createStory(title: String, author: String, summary: String) async throws -> Story {
        try await Task.sleep(for: .milliseconds(400))
        return Story(id: UUID().uuidString, title: title, author: author, summary: summary, coverIcon: "book.fill", readTime: 5, isFavorite: false)
    }

    func deleteStory(id: String) async throws {
        try await Task.sleep(for: .milliseconds(300))
    }
}
