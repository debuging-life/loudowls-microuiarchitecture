import Foundation
import MicroUICore

protocol FavoriteScreenDataSource: Sendable {
    func fetchAll() async throws -> [FavoriteScreenItem]
    func fetchDetail(id: String) async throws -> FavoriteScreenItem
    func create(name: String) async throws -> FavoriteScreenItem
    func delete(id: String) async throws
}

// MARK: - Mock

struct MockFavoriteScreenDataSource: FavoriteScreenDataSource {

    func fetchAll() async throws -> [FavoriteScreenItem] {
        try await Task.sleep(for: .milliseconds(500))
        return FavoriteScreenItem.mock
    }

    func fetchDetail(id: String) async throws -> FavoriteScreenItem {
        try await Task.sleep(for: .milliseconds(300))
        guard let item = FavoriteScreenItem.mock.first(where: { $0.id == id }) else {
            throw OwlsNetworkError.notFound
        }
        return item
    }

    func create(name: String) async throws -> FavoriteScreenItem {
        try await Task.sleep(for: .milliseconds(400))
        return FavoriteScreenItem(id: UUID().uuidString, title: name, subtitle: "Newly created", iconName: "plus.circle.fill", createdAt: Date())
    }

    func delete(id: String) async throws {
        try await Task.sleep(for: .milliseconds(300))
    }
}

// MARK: - Live (swap Mock → Live when API is ready)
//
// final class LiveFavoriteScreenDataSource: OwlsBaseService, FavoriteScreenDataSource {
//     func fetchAll() async throws -> [FavoriteScreenItem] {
//         try await request(FavoriteScreenAPI.list)
//     }
//     func fetchDetail(id: String) async throws -> FavoriteScreenItem {
//         try await request(FavoriteScreenAPI.detail(id: id))
//     }
//     func create(name: String) async throws -> FavoriteScreenItem {
//         try await request(FavoriteScreenAPI.create(FavoriteScreenCreateRequest(name: name)))
//     }
//     func delete(id: String) async throws {
//         try await requestVoid(FavoriteScreenAPI.delete(id: id))
//     }
// }