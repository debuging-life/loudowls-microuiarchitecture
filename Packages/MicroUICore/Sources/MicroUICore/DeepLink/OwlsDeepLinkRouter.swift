import Foundation
import Factory

// MARK: - Deep Link Router

public final class OwlsDeepLinkRouter: @unchecked Sendable {

    public static let shared = OwlsDeepLinkRouter()

    private var handlers: [OwlsDeepLinkHandler] = []

    private init() {}

    // MARK: - Register

    public func register(_ handler: OwlsDeepLinkHandler) {
        handlers.append(handler)
    }

    // MARK: - Route

    @discardableResult
    public func route(_ deepLink: OwlsDeepLink) -> Bool {
        OwlsAnalytics.track(OwlsAnalyticsEvent(
            name: "deep_link_received",
            category: .lifecycle,
            properties: ["module": deepLink.module, "path": deepLink.path]
        ))

        for handler in handlers {
            if handler.supportedModules.contains(deepLink.module) {
                if handler.handle(deepLink) {
                    return true
                }
            }
        }

        #if DEBUG
        print("[DeepLink] No handler found for: \(deepLink.module)/\(deepLink.path)")
        #endif
        return false
    }

    // MARK: - Route from URL

    @discardableResult
    public func route(url: URL) -> Bool {
        guard let deepLink = OwlsDeepLink.from(url: url) else {
            #if DEBUG
            print("[DeepLink] Invalid URL: \(url)")
            #endif
            return false
        }
        return route(deepLink)
    }

    // MARK: - Route from Push Notification

    @discardableResult
    public func route(userInfo: [AnyHashable: Any]) -> Bool {
        guard let deepLink = OwlsDeepLink.from(userInfo: userInfo) else { return false }
        return route(deepLink)
    }
}
