import Foundation
import MicroUICore

// MARK: - Home Module API Routes

enum HomeAPI: OwlsAPIRoute {

    case listAccounts
    case accountDetail(id: String)
    case transactions(accountId: String, page: Int, limit: Int = 20)
    case closeAccount(id: String)

    // MARK: - Path

    var path: String {
        switch self {
        case .listAccounts:
            "/v1/accounts"
        case .accountDetail(let id):
            "/v1/accounts/\(id)"
        case .transactions(let accountId, _, _):
            "/v1/accounts/\(accountId)/transactions"
        case .closeAccount(let id):
            "/v1/accounts/\(id)"
        }
    }

    // MARK: - Method

    var method: HTTPMethod {
        switch self {
        case .listAccounts, .accountDetail, .transactions: .get
        case .closeAccount: .delete
        }
    }

    // MARK: - Query Items

    var queryItems: [URLQueryItem]? {
        switch self {
        case .transactions(_, let page, let limit):
            [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
        default:
            nil
        }
    }
}

// MARK: - Usage Example
//
// final class LiveHomeDataSource: OwlsBaseService, HomeDataSource {
//
//     func fetchItems() async throws -> [HomeItem] {
//         // Auth token injected automatically
//         // URLComponents built from HomeAPI enum
//         // → GET https://api.example.com/v1/accounts
//         try await request(HomeAPI.listAccounts)
//     }
//
//     func fetchTransactions(accountId: String) async throws -> [Transaction] {
//         // → GET https://api.example.com/v1/accounts/123/transactions?page=1&limit=20
//         try await request(HomeAPI.transactions(accountId: accountId, page: 1))
//     }
// }
