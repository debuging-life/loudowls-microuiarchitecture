import Foundation
import MicroUICore

enum OwlAboutAPI: OwlsAPIRoute {

    case list
    case detail(id: String)
    case create(OwlAboutCreateRequest)
    case update(id: String, OwlAboutUpdateRequest)
    case delete(id: String)

    var path: String {
        switch self {
        case .list:
            "/v1/owlabout"
        case .detail(let id):
            "/v1/owlabout/\(id)"
        case .create:
            "/v1/owlabout"
        case .update(let id, _):
            "/v1/owlabout/\(id)"
        case .delete(let id):
            "/v1/owlabout/\(id)"
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

struct OwlAboutCreateRequest: Encodable, Sendable {
    let name: String
}

struct OwlAboutUpdateRequest: Encodable, Sendable {
    let name: String
}