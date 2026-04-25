import Foundation
import Observation

// MARK: - Mock Registry

@Observable
public final class OwlsMockRegistry: @unchecked Sendable {

    public static let shared = OwlsMockRegistry()

    public private(set) var providers: [OwlsMockProvider] = []
    public var enabledMockIds: Set<String> = []

    private let storageKey = "owls.mocks.enabled"
    private let lock = NSLock()

    private init() {
        loadEnabledMocks()
    }

    // MARK: - Register

    public func register(_ provider: OwlsMockProvider) {
        lock.lock()
        defer { lock.unlock() }
        // Avoid duplicates if module re-registers
        providers.removeAll { $0.moduleName == provider.moduleName }
        providers.append(provider)
    }

    // MARK: - Lookup

    /// Returns the enabled mock matching this endpoint + method, if any.
    public func enabledMock(for endpoint: String, method: HTTPMethod) -> OwlsMockItem? {
        for provider in providers {
            for item in provider.mockItems() {
                if item.endpoint == endpoint,
                   item.method == method,
                   enabledMockIds.contains(item.id) {
                    return item
                }
            }
        }
        return nil
    }

    /// All mocks across all providers, grouped by module.
    public func allMocks() -> [String: [OwlsMockItem]] {
        var grouped: [String: [OwlsMockItem]] = [:]
        for provider in providers {
            grouped[provider.moduleName] = provider.mockItems()
        }
        return grouped
    }

    public func allMocksFlat() -> [OwlsMockItem] {
        providers.flatMap { $0.mockItems() }
    }

    // MARK: - Toggle

    public func isEnabled(_ id: String) -> Bool {
        enabledMockIds.contains(id)
    }

    public func setEnabled(_ id: String, enabled: Bool, exclusiveByEndpoint: Bool = true) {
        lock.lock()
        defer { lock.unlock() }

        if enabled {
            // Only one mock per endpoint can be active at a time
            if exclusiveByEndpoint, let item = findItem(id: id) {
                let conflicting = allMocksFlat()
                    .filter { $0.endpoint == item.endpoint && $0.method == item.method && $0.id != id }
                    .map(\.id)
                enabledMockIds.subtract(conflicting)
            }
            enabledMockIds.insert(id)
        } else {
            enabledMockIds.remove(id)
        }
        saveEnabledMocks()

        OwlsEventBus.shared.post(OwlsEvent("mock.toggled", data: ["id": id, "enabled": "\(enabled)"]))
    }

    public func disableAll() {
        lock.lock()
        defer { lock.unlock() }
        enabledMockIds.removeAll()
        saveEnabledMocks()
    }

    private func findItem(id: String) -> OwlsMockItem? {
        allMocksFlat().first { $0.id == id }
    }

    // MARK: - Persistence

    private func loadEnabledMocks() {
        let saved = UserDefaults.standard.array(forKey: storageKey) as? [String] ?? []
        enabledMockIds = Set(saved)
    }

    private func saveEnabledMocks() {
        UserDefaults.standard.set(Array(enabledMockIds), forKey: storageKey)
    }
}
