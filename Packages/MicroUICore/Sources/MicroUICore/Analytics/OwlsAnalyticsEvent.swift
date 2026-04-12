import Foundation

// MARK: - Event

public struct OwlsAnalyticsEvent: Sendable {
    public let name: String
    public let category: Category
    public let properties: [String: String]
    public let timestamp: Date

    public init(
        name: String,
        category: Category = .interaction,
        properties: [String: String] = [:],
        timestamp: Date = Date()
    ) {
        self.name = name
        self.category = category
        self.properties = properties
        self.timestamp = timestamp
    }

    // MARK: - Category

    public enum Category: String, Sendable {
        case screenView = "screen_view"
        case interaction = "interaction"
        case transaction = "transaction"
        case error = "error"
        case lifecycle = "lifecycle"
    }

    // MARK: - Convenience Builders

    public static func screenViewed(_ name: String, module: String) -> OwlsAnalyticsEvent {
        OwlsAnalyticsEvent(
            name: "screen_viewed",
            category: .screenView,
            properties: ["screen_name": name, "module": module]
        )
    }

    public static func buttonTapped(_ name: String, screen: String) -> OwlsAnalyticsEvent {
        OwlsAnalyticsEvent(
            name: "button_tapped",
            category: .interaction,
            properties: ["button": name, "screen": screen]
        )
    }

    public static func apiCalled(_ endpoint: String, success: Bool, duration: TimeInterval) -> OwlsAnalyticsEvent {
        OwlsAnalyticsEvent(
            name: "api_call",
            category: .transaction,
            properties: [
                "endpoint": endpoint,
                "success": "\(success)",
                "duration_ms": "\(Int(duration * 1000))"
            ]
        )
    }

    public static func errorOccurred(_ error: String, module: String, screen: String) -> OwlsAnalyticsEvent {
        OwlsAnalyticsEvent(
            name: "error",
            category: .error,
            properties: ["error": error, "module": module, "screen": screen]
        )
    }

    public static func appLifecycle(_ state: String) -> OwlsAnalyticsEvent {
        OwlsAnalyticsEvent(name: state, category: .lifecycle)
    }
}
