import Foundation
import MicroUICore

enum FavoriteScreenAPI: OwlsAPIRoute {

    case list
    case detail(id: String)
    case create(FavoriteScreenCreateRequest)
    case update(id: String, FavoriteScreenUpdateRequest)
    case delete(id: String)

    var path: String {
        switch self {
        case .list:
            "/v1/favoritescreen"
        case .detail(let id):
            "/v1/favoritescreen/\(id)"
        case .create:
            "/v1/favoritescreen"
        case .update(let id, _):
            "/v1/favoritescreen/\(id)"
        case .delete(let id):
            "/v1/favoritescreen/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list, .detail: .get
        case .create: .post
        case .update: .put
        case .delete: .delete
        }
    }

    var body: Data? {
        switch self {
        case .create(let payload): Self.encode(payload)
        case .update(_, let payload): Self.encode(payload)
        default: nil
        }
    }
}

struct FavoriteScreenCreateRequest: Encodable, Sendable {
    let name: String
}

struct FavoriteScreenUpdateRequest: Encodable, Sendable {
    let name: String
}