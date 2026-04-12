import Foundation
import Factory

// MARK: - Feature Flag Provider Protocol

public protocol OwlsFeatureFlagProvider: Sendable {
    func isEnabled(_ flag: String) -> Bool
    func value<T>(_ flag: String, defaultValue: T) -> T
    func fetchFlags() async throws
}

// MARK: - Feature Flag Keys

public enum OwlsFeatureFlag {
    public static func isEnabled(_ key: String) -> Bool {
        let provider = Container.shared.featureFlagProvider()
        return provider?.isEnabled(key) ?? false
    }

    public static func value<T>(_ key: String, defaultValue: T) -> T {
        let provider = Container.shared.featureFlagProvider()
        return provider?.value(key, defaultValue: defaultValue) ?? defaultValue
    }
}

// MARK: - Container

extension Container {
    public var featureFlagProvider: Factory<OwlsFeatureFlagProvider?> { self { nil } }
}
