import Foundation

// MARK: - HTTP Method

public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

// MARK: - API Route Protocol

public protocol OwlsAPIRoute: Sendable {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
    var headers: [String: String] { get }
}

// MARK: - Defaults

extension OwlsAPIRoute {
    public var method: HTTPMethod { .get }
    public var queryItems: [URLQueryItem]? { nil }
    public var body: Data? { nil }
    public var headers: [String: String] { [:] }
}

// MARK: - Body Encoding Helper

extension OwlsAPIRoute {
    public static func encode(_ value: some Encodable) -> Data? {
        try? JSONEncoder().encode(value)
    }
}

// MARK: - URLRequest Builder

extension OwlsAPIRoute {

    public func toURLRequest(baseURL: URL) -> URLRequest {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.port = baseURL.port
        components.path = buildPath(basePath: baseURL.path)
        components.queryItems = queryItems?.isEmpty == false ? queryItems : nil

        guard let url = components.url else {
            // Fallback — should never happen with valid baseURL + path
            var fallback = URLRequest(url: baseURL.appendingPathComponent(path))
            fallback.httpMethod = method.rawValue
            return fallback
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body

        // Default headers for JSON body
        if body != nil, headers["Content-Type"] == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }

    private func buildPath(basePath: String) -> String {
        let base = basePath.hasSuffix("/") ? String(basePath.dropLast()) : basePath
        let route = path.hasPrefix("/") ? path : "/\(path)"
        return base + route
    }
}
