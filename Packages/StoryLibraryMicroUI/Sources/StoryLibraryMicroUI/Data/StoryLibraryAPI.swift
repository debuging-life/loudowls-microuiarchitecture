import Foundation
import MicroUICore

enum StoryLibraryAPI: OwlsAPIRoute {

    case list
    case detail(id: String)
    case create(StoryLibraryCreateRequest)
    case update(id: String, StoryLibraryUpdateRequest)
    case delete(id: String)

    // MARK: - Path

    var path: String {
        switch self {
        case .list:
            "/v1/storylibrary"
        case .detail(let id):
            "/v1/storylibrary/\(id)"
        case .create:
            "/v1/storylibrary"
        case .update(let id, _):
            "/v1/storylibrary/\(id)"
        case .delete(let id):
            "/v1/storylibrary/\(id)"
        }
    }

    // MARK: - Method

    var method: HTTPMethod {
        switch self {
        case .list, .detail: .get
        case .create: .post
        case .update: .put
        case .delete: .delete
        }
    }

    // MARK: - Body

    var body: Data? {
        switch self {
        case .create(let payload): Self.encode(payload)
        case .update(_, let payload): Self.encode(payload)
        default: nil
        }
    }
}

// MARK: - Request / Response Models

struct StoryLibraryCreateRequest: Encodable, Sendable {
    let name: String
}

struct StoryLibraryUpdateRequest: Encodable, Sendable {
    let name: String
}

// MARK: - Live DataSource (swap in when API is ready)
//
// final class LiveStoryLibraryDataSource: OwlsBaseService, StoryLibraryDataSource {
//     func fetchData() async throws -> [String] {
//         try await request(StoryLibraryAPI.list)
//     }
// }
