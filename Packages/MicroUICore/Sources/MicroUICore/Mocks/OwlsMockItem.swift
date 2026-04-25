import Foundation

// MARK: - Mock Item

public struct OwlsMockItem: Identifiable, Sendable {

    public let id: String           // e.g. "stories.list.success"
    public let name: String         // e.g. "Stories — Success"
    public let module: String       // e.g. "FeatureHomeMicroUI"
    public let endpoint: String     // matches OwlsAPIRoute.path, e.g. "/v1/stories"
    public let method: HTTPMethod   // matches OwlsAPIRoute.method
    public let jsonFilename: String // e.g. "storiesSuccess.json"
    public let bundle: Bundle       // the module's resource bundle (Bundle.module)
    public let statusCode: Int      // 200 for success, 4xx/5xx for failure
    public let category: Category

    public enum Category: String, Sendable, CaseIterable {
        case success = "Success"
        case empty = "Empty"
        case failure = "Failure"
        case edgeCase = "Edge Case"
    }

    public init(
        id: String,
        name: String,
        module: String,
        endpoint: String,
        method: HTTPMethod = .get,
        jsonFilename: String,
        bundle: Bundle,
        statusCode: Int = 200,
        category: Category = .success
    ) {
        self.id = id
        self.name = name
        self.module = module
        self.endpoint = endpoint
        self.method = method
        self.jsonFilename = jsonFilename
        self.bundle = bundle
        self.statusCode = statusCode
        self.category = category
    }

    /// Convenience initializer — pulls endpoint + method from an API route.
    /// This keeps the mock declaration in sync with the API route enum.
    public init(
        id: String,
        name: String,
        module: String,
        route: any OwlsAPIRoute,
        jsonFilename: String,
        bundle: Bundle,
        statusCode: Int = 200,
        category: Category = .success
    ) {
        self.init(
            id: id,
            name: name,
            module: module,
            endpoint: route.path,
            method: route.method,
            jsonFilename: jsonFilename,
            bundle: bundle,
            statusCode: statusCode,
            category: category
        )
    }

    // MARK: - Load JSON

    public func loadJSON() throws -> Data {
        let baseName = jsonFilename.replacingOccurrences(of: ".json", with: "")
        guard let url = bundle.url(forResource: baseName, withExtension: "json") else {
            throw OwlsMockError.fileNotFound(jsonFilename)
        }
        return try Data(contentsOf: url)
    }
}

// MARK: - Mock Provider Protocol

public protocol OwlsMockProvider: Sendable {
    var moduleName: String { get }
    func mockItems() -> [OwlsMockItem]
}

// MARK: - Errors

public enum OwlsMockError: LocalizedError {
    case fileNotFound(String)
    case decodingFailed(String)

    public var errorDescription: String? {
        switch self {
        case .fileNotFound(let name): "Mock JSON not found: \(name)"
        case .decodingFailed(let detail): "Mock decoding failed: \(detail)"
        }
    }
}
