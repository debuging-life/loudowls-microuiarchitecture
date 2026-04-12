import Foundation
import MicroUICore

// MARK: - Console Analytics (Debug)

struct ConsoleAnalyticsProvider: OwlsAnalyticsProvider {

    func track(_ event: OwlsAnalyticsEvent) {
        let props = event.properties.map { "\($0.key)=\($0.value)" }.joined(separator: ", ")
        print("[ConsoleAnalytics] [\(event.category.rawValue)] \(event.name) {\(props)}")
    }

    func setUserProperty(_ key: String, value: String) {
        print("[ConsoleAnalytics] UserProperty: \(key)=\(value)")
    }

    func setUserId(_ id: String?) {
        print("[ConsoleAnalytics] UserId: \(id ?? "nil")")
    }
}

// MARK: - Firebase Analytics (swap in for production)
//
// struct FirebaseAnalyticsProvider: OwlsAnalyticsProvider {
//     func track(_ event: OwlsAnalyticsEvent) {
//         Analytics.logEvent(event.name, parameters: event.properties)
//     }
//     func setUserProperty(_ key: String, value: String) {
//         Analytics.setUserProperty(value, forName: key)
//     }
//     func setUserId(_ id: String?) {
//         Analytics.setUserID(id)
//     }
// }
