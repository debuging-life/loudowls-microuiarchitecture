import Foundation

// MARK: - Deep Link Handler Protocol

public protocol OwlsDeepLinkHandler: Sendable {
    var supportedModules: [String] { get }
    func handle(_ deepLink: OwlsDeepLink) -> Bool
}
