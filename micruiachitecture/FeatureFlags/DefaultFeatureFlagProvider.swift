import Foundation
import MicroUICore

// MARK: - Default Feature Flag Provider

final class DefaultFeatureFlagProvider: OwlsFeatureFlagProvider, @unchecked Sendable {

    private var flags: [String: Any] = [:]

    init() {
        // Default: all modules enabled
        loadDefaults()
    }

    // MARK: - OwlsFeatureFlagProvider

    func isEnabled(_ flag: String) -> Bool {
        flags[flag] as? Bool ?? false
    }

    func value<T>(_ flag: String, defaultValue: T) -> T {
        flags[flag] as? T ?? defaultValue
    }

    func fetchFlags() async throws {
        // TODO: Replace with real API call
        // GET /api/feature-flags
        // Response: { "module.home.enabled": true, "module.transfers.enabled": false, ... }
        try await Task.sleep(for: .milliseconds(300))

        // Simulated server response
        let serverFlags: [String: Any] = [
            "module.home.enabled": true,
            "module.profile.enabled": true,
            "module.auth.enabled": true,
            "module.storylibrary.enabled": true,
            "module.transfers.enabled": true,
            "module.aboutscreen.enabled": true,
            "ui.dark_mode.enabled": true,
            "feature.push_notifications.enabled": true,
            "max_retry_count": 3,
        ]

        flags.merge(serverFlags) { _, new in new }
    }

    // MARK: - Defaults

    private func loadDefaults() {
        flags = [
            "module.home.enabled": true,
            "module.profile.enabled": true,
            "module.auth.enabled": true,
            "module.storylibrary.enabled": true,
            "module.transfers.enabled": true,
            "module.aboutscreen.enabled": true,
        ]
    }
}
