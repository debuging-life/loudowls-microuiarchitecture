import Foundation
import MicroUICore

protocol OwlScreenDataSource: Sendable {
    func fetchAll() async throws -> [OwlScreenItem]
    func fetchDetail(id: String) async throws -> OwlScreenItem
    func create(name: String) async throws -> OwlScreenItem
    func delete(id: String) async throws
}

// MARK: - Mock

struct MockOwlScreenDataSource: OwlScreenDataSource {

    func fetchAll() async throws -> [OwlScreenItem] {
        try await Task.sleep(for: .milliseconds(500))
        return OwlScreenItem.mock
    }

    func fetchDetail(id: String) async throws -> OwlScreenItem {
        try await Task.sleep(for: .milliseconds(300))
        guard let item = OwlScreenItem.mock.first(where: { $0.id == id }) else {
            throw OwlsNetworkError.notFound
        }
        return item
    }

    func create(name: String) async throws -> OwlScreenItem {
        try await Task.sleep(for: .milliseconds(400))
        return OwlScreenItem(id: UUID().uuidString, title: name, subtitle: "Newly created", iconName: "plus.circle.fill", createdAt: Date())
    }

    func delete(id: String) async throws {
        try await Task.sleep(for: .milliseconds(300))
    }
}

// MARK: - Live (swap Mock → Live when API is ready)
//
// final class LiveOwlScreenDataSource: OwlsBaseService, OwlScreenDataSource {
//     func fetchAll() async throws -> [OwlScreenItem] {
//         try await request(OwlScreenAPI.list)
//     }
//     func fetchDetail(id: String) async throws -> OwlScreenItem {
//         try await request(OwlScreenAPI.detail(id: id))
//     }
//     func create(name: String) async throws -> OwlScreenItem {
//         try await request(OwlScreenAPI.create(OwlScreenCreateRequest(name: name)))
//     }
//     func delete(id: String) async throws {
//         try await requestVoid(OwlScreenAPI.delete(id: id))
//     }
// }