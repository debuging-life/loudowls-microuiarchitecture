import Foundation
import MicroUICore

protocol HomeDataSource: Sendable {
    func fetchItems() async throws -> [HomeItem]
}

// MARK: - Mock (used now)

struct MockHomeDataSource: HomeDataSource {
    func fetchItems() async throws -> [HomeItem] {
        try await Task.sleep(for: .milliseconds(300))
        return HomeItem.mock
    }
}

// MARK: - Live (swap in when API is ready)
//
// final class LiveHomeDataSource: OwlsBaseService, HomeDataSource {
//     func fetchItems() async throws -> [HomeItem] {
//         try await request(HomeAPI.listAccounts)
//         // ✅ Auth token injected automatically
//         // ✅ URL built via URLComponents from HomeAPI enum
//         // ✅ 401 → auto-refresh → retry
//     }
// }
