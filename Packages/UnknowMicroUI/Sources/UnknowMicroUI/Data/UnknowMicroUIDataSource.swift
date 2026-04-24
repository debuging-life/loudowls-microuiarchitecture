import Foundation
import MicroUICore

protocol UnknowDataSource: Sendable {
    func fetchAll() async throws -> [UnknowItem]
    func fetchDetail(id: String) async throws -> UnknowItem
    func create(name: String) async throws -> UnknowItem
    func delete(id: String) async throws
}

// MARK: - Mock

struct MockUnknowDataSource: UnknowDataSource {

    func fetchAll() async throws -> [UnknowItem] {
        try await Task.sleep(for: .milliseconds(500))
        return UnknowItem.mock
    }

    func fetchDetail(id: String) async throws -> UnknowItem {
        try await Task.sleep(for: .milliseconds(300))
        guard let item = UnknowItem.mock.first(where: { $0.id == id }) else {
            throw OwlsNetworkError.notFound
        }
        return item
    }

    func create(name: String) async throws -> UnknowItem {
        try await Task.sleep(for: .milliseconds(400))
        return UnknowItem(id: UUID().uuidString, title: name, subtitle: "Newly created", iconName: "plus.circle.fill", createdAt: Date())
    }

    func delete(id: String) async throws {
        try await Task.sleep(for: .milliseconds(300))
    }
}

// MARK: - Live (swap Mock → Live when API is ready)
//
// final class LiveUnknowDataSource: OwlsBaseService, UnknowDataSource {
//     func fetchAll() async throws -> [UnknowItem] {
//         try await request(UnknowAPI.list)
//     }
//     func fetchDetail(id: String) async throws -> UnknowItem {
//         try await request(UnknowAPI.detail(id: id))
//     }
//     func create(name: String) async throws -> UnknowItem {
//         try await request(UnknowAPI.create(UnknowCreateRequest(name: name)))
//     }
//     func delete(id: String) async throws {
//         try await requestVoid(UnknowAPI.delete(id: id))
//     }
// }