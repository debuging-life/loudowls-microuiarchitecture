import Foundation
import MicroUICore

protocol HomeDataSource: Sendable {
    func fetchStories(page: Int, limit: Int) async throws -> [Story]
    func createStory(title: String, author: String, summary: String) async throws -> Story
    func deleteStory(id: String) async throws
}

// MARK: - Mock

struct MockHomeDataSource: HomeDataSource {

    func fetchStories(page: Int, limit: Int) async throws -> [Story] {
        try await Task.sleep(for: .milliseconds(800))

        // Simulate paginated API — 30 total stories, served in pages
        let allStories = generateStories(count: 30)
        let start = (page - 1) * limit
        guard start < allStories.count else { return [] }
        let end = min(start + limit, allStories.count)
        return Array(allStories[start..<end])
    }

    func createStory(title: String, author: String, summary: String) async throws -> Story {
        try await Task.sleep(for: .milliseconds(400))
        return Story(id: UUID().uuidString, title: title, author: author, summary: summary, coverIcon: "book.fill", readTime: 5, isFavorite: false)
    }

    func deleteStory(id: String) async throws {
        try await Task.sleep(for: .milliseconds(300))
    }

    // MARK: - Generate Fake Data

    private func generateStories(count: Int) -> [Story] {
        let titles = [
            ("The Wise Owl", "bird.fill", "Luna Woods"),
            ("The Star Collector", "star.fill", "Mira Sky"),
            ("The Brave Little Cloud", "cloud.fill", "Aiden Rain"),
            ("The Magic Garden", "leaf.fill", "Flora Green"),
            ("The Moonlight Express", "moon.fill", "Kai Night"),
            ("The Color Thief", "paintpalette.fill", "Iris Paint"),
            ("The Singing River", "water.waves", "River Song"),
            ("The Lost Constellation", "sparkles", "Nova Star"),
            ("The Friendly Dragon", "flame.fill", "Drake Fire"),
            ("The Secret Library", "books.vertical.fill", "Page Turner"),
        ]

        return (0..<count).map { i in
            let template = titles[i % titles.count]
            let suffix = i >= titles.count ? " (Part \(i / titles.count + 1))" : ""
            return Story(
                id: "\(i + 1)",
                title: "\(template.0)\(suffix)",
                author: template.2,
                summary: "A wonderful story about adventure, friendship, and discovery. Chapter \(i + 1) of the HooTales collection.",
                coverIcon: template.1,
                readTime: Int.random(in: 3...12),
                isFavorite: i % 4 == 0
            )
        }
    }
}
