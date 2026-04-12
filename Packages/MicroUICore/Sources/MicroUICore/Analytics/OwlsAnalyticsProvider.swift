import Foundation

// MARK: - Analytics Provider Protocol

public protocol OwlsAnalyticsProvider: Sendable {
    func track(_ event: OwlsAnalyticsEvent)
    func setUserProperty(_ key: String, value: String)
    func setUserId(_ id: String?)
}
