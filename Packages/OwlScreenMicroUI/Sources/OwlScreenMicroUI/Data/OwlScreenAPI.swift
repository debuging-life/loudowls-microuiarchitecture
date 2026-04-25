import Foundation
import MicroUICore

enum OwlScreenAPI: OwlsAPIRoute {

    case list
    case detail(id: String)
    case create(OwlScreenCreateRequest)
    case update(id: String, OwlScreenUpdateRequest)
    case delete(id: String)

    var path: String {
        switch self {
        case .list:
            "/v1/owlscreen"
        case .detail(let id):
            "/v1/owlscreen/\(id)"
        case .create:
            "/v1/owlscreen"
        case .update(let id, _):
            "/v1/owlscreen/\(id)"
        case .delete(let id):
            "/v1/owlscreen/\(id)"
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

struct OwlScreenCreateRequest: Encodable, Sendable {
    let name: String
}

struct OwlScreenUpdateRequest: Encodable, Sendable {
    let name: String
}