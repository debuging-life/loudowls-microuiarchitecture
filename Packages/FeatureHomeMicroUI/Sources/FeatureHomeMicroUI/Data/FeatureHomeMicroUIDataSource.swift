import Foundation
import MicroUICore

protocol HomeDataSource: Sendable {
    func fetchStories(page: Int, limit: Int) async throws -> [Story]
    func createStory(title: String, author: String, summary: String) async throws -> Story
    func deleteStory(id: String) async throws
}

// MARK: - Live (uses OwlsBaseService — respects mocks via Debug Drawer)

final class LiveHomeDataSource: OwlsBaseService, HomeDataSource {

    func fetchStories(page: Int, limit: Int) async throws -> [Story] {
        // Mock interception happens automatically in DEBUG
        try await request(HomeAPI.list(page: page, limit: limit))
    }

    func createStory(title: String, author: String, summary: String) async throws -> Story {
        try await request(HomeAPI.create(title: title, author: author, summary: summary))
    }

    func deleteStory(id: String) async throws {
        try await requestVoid(HomeAPI.delete(id: id))
    }
}
