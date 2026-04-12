import Foundation
import MicroUICore

protocol StoryLibraryDataSource: Sendable {
    func fetchAll() async throws -> [StoryLibraryItem]
    func fetchDetail(id: String) async throws -> StoryLibraryItem
    func create(name: String) async throws -> StoryLibraryItem
    func delete(id: String) async throws
}

// MARK: - Mock (returns fake data, simulates network delay)

struct MockStoryLibraryDataSource: StoryLibraryDataSource {

    func fetchAll() async throws -> [StoryLibraryItem] {
        try await Task.sleep(for: .milliseconds(500))
        return StoryLibraryItem.mock
    }

    func fetchDetail(id: String) async throws -> StoryLibraryItem {
        try await Task.sleep(for: .milliseconds(300))
        guard let item = StoryLibraryItem.mock.first(where: { $0.id == id }) else {
            throw OwlsNetworkError.notFound
        }
        return item
    }

    func create(name: String) async throws -> StoryLibraryItem {
        try await Task.sleep(for: .milliseconds(400))
        return StoryLibraryItem(id: UUID().uuidString, title: name, subtitle: "Newly created", iconName: "plus.circle.fill", createdAt: Date())
    }

    func delete(id: String) async throws {
        try await Task.sleep(for: .milliseconds(300))
    }
}

// MARK: - Live (swap Mock → Live when API is ready)
//
// final class LiveStoryLibraryDataSource: OwlsBaseService, StoryLibraryDataSource {
//     func fetchAll() async throws -> [StoryLibraryItem] {
//         try await request(StoryLibraryAPI.list)
//     }
//     func fetchDetail(id: String) async throws -> StoryLibraryItem {
//         try await request(StoryLibraryAPI.detail(id: id))
//     }
//     func create(name: String) async throws -> StoryLibraryItem {
//         try await request(StoryLibraryAPI.create(StoryLibraryCreateRequest(name: name)))
//     }
//     func delete(id: String) async throws {
//         try await requestVoid(StoryLibraryAPI.delete(id: id))
//     }
// }
