import Foundation
import MicroUICore

protocol OwlAboutDataSource: Sendable {
    func fetchAll() async throws -> [OwlAboutItem]
    func fetchDetail(id: String) async throws -> OwlAboutItem
    func create(name: String) async throws -> OwlAboutItem
    func delete(id: String) async throws
}

// MARK: - Mock

struct MockOwlAboutDataSource: OwlAboutDataSource {

    func fetchAll() async throws -> [OwlAboutItem] {
        try await Task.sleep(for: .milliseconds(500))
        return OwlAboutItem.mock
    }

    func fetchDetail(id: String) async throws -> OwlAboutItem {
        try await Task.sleep(for: .milliseconds(300))
        guard let item = OwlAboutItem.mock.first(where: { $0.id == id }) else {
            throw OwlsNetworkError.notFound
        }
        return item
    }

    func create(name: String) async throws -> OwlAboutItem {
        try await Task.sleep(for: .milliseconds(400))
        return OwlAboutItem(id: UUID().uuidString, title: name, subtitle: "Newly created", iconName: "plus.circle.fill", createdAt: Date())
    }

    func delete(id: String) async throws {
        try await Task.sleep(for: .milliseconds(300))
    }
}

// MARK: - Live (swap Mock → Live when API is ready)
//
// final class LiveOwlAboutDataSource: OwlsBaseService, OwlAboutDataSource {
//     func fetchAll() async throws -> [OwlAboutItem] {
//         try await request(OwlAboutAPI.list)
//     }
//     func fetchDetail(id: String) async throws -> OwlAboutItem {
//         try await request(OwlAboutAPI.detail(id: id))
//     }
//     func create(name: String) async throws -> OwlAboutItem {
//         try await request(OwlAboutAPI.create(OwlAboutCreateRequest(name: name)))
//     }
//     func delete(id: String) async throws {
//         try await requestVoid(OwlAboutAPI.delete(id: id))
//     }
// }