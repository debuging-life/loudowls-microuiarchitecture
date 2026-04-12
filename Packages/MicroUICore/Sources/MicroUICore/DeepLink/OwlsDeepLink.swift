import Foundation

// MARK: - Deep Link

public struct OwlsDeepLink: Sendable {
    public let module: String
    public let path: String
    public let parameters: [String: String]

    public init(module: String, path: String = "", parameters: [String: String] = [:]) {
        self.module = module
        self.path = path
        self.parameters = parameters
    }

    // MARK: - Parse URL

    public static func from(url: URL) -> OwlsDeepLink? {
        // Format: owlsapp://module/path?key=value
        guard let host = url.host else { return nil }

        let pathComponents = url.pathComponents.filter { $0 != "/" }
        let path = pathComponents.joined(separator: "/")

        var params: [String: String] = [:]
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            components.queryItems?.forEach { params[$0.name] = $0.value }
        }

        return OwlsDeepLink(module: host, path: path, parameters: params)
    }

    // MARK: - Parse Push Notification

    public static func from(userInfo: [AnyHashable: Any]) -> OwlsDeepLink? {
        guard let module = userInfo["module"] as? String else { return nil }
        let path = userInfo["path"] as? String ?? ""
        let params = userInfo["params"] as? [String: String] ?? [:]
        return OwlsDeepLink(module: module, path: path, parameters: params)
    }
}
