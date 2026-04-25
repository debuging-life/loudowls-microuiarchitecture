import Foundation
import MicroUICore

// MARK: - Home Module API Routes

enum HomeAPI: OwlsAPIRoute {

    case list(page: Int, limit: Int)
    case detail(id: String)
    case create(title: String, author: String, summary: String)
    case delete(id: String)

    // MARK: - Path

    var path: String {
        switch self {
        case .list, .create:
            "/v1/home"
        case .detail(let id), .delete(let id):
            "/v1/home/\(id)"
        }
    }

    // MARK: - Method

    var method: HTTPMethod {
        switch self {
        case .list, .detail: .get
        case .create: .post
        case .delete: .delete
        }
    }

    // MARK: - Query Items

    var queryItems: [URLQueryItem]? {
        switch self {
        case .list(let page, let limit):
            [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
        default: nil
        }
    }

    // MARK: - Body

    var body: Data? {
        switch self {
        case .create(let title, let author, let summary):
            Self.encode(CreateStoryRequest(title: title, author: author, summary: summary))
        default: nil
        }
    }
}

// MARK: - Models

struct CreateStoryRequest: Encodable, Sendable {
    let title: String
    let author: String
    let summary: String
}
