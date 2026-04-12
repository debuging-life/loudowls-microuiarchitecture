import Foundation
import Factory

// MARK: - Analytics Engine

public final class OwlsAnalytics: Sendable {

    public static func track(_ event: OwlsAnalyticsEvent) {
        let providers = Container.shared.analyticsProviders()
        for provider in providers {
            provider.track(event)
        }

        #if DEBUG
        print("[Analytics] \(event.category.rawValue): \(event.name) \(event.properties)")
        #endif
    }

    public static func setUserId(_ id: String?) {
        let providers = Container.shared.analyticsProviders()
        for provider in providers {
            provider.setUserId(id)
        }
    }

    public static func setUserProperty(_ key: String, value: String) {
        let providers = Container.shared.analyticsProviders()
        for provider in providers {
            provider.setUserProperty(key, value: value)
        }
    }
}

// MARK: - Container

extension Container {
    public var analyticsProviders: Factory<[OwlsAnalyticsProvider]> {
        self { [] }
    }
}
