import Foundation
import MicroUICore

enum UnknowAPI: OwlsAPIRoute {

    case list
    case detail(id: String)
    case create(UnknowCreateRequest)
    case update(id: String, UnknowUpdateRequest)
    case delete(id: String)

    var path: String {
        switch self {
        case .list:
            "/v1/unknow"
        case .detail(let id):
            "/v1/unknow/\(id)"
        case .create:
            "/v1/unknow"
        case .update(let id, _):
            "/v1/unknow/\(id)"
        case .delete(let id):
            "/v1/unknow/\(id)"
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

struct UnknowCreateRequest: Encodable, Sendable {
    let name: String
}

struct UnknowUpdateRequest: Encodable, Sendable {
    let name: String
}