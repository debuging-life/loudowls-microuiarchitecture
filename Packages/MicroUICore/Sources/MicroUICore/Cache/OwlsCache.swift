import Foundation

// MARK: - Cache Entry

private struct CacheEntry<T> {
    let value: T
    let timestamp: Date
    let ttl: TimeInterval

    var isExpired: Bool { Date().timeIntervalSince(timestamp) > ttl }
}

// MARK: - Cache

public final class OwlsCache: @unchecked Sendable {

    public static let shared = OwlsCache()

    private var storage: [String: Any] = [:]
    private let lock = NSLock()
    private let defaultTTL: TimeInterval

    public init(defaultTTL: TimeInterval = 300) { // 5 minutes
        self.defaultTTL = defaultTTL
    }

    // MARK: - Get or Fetch

    public func get<T: Sendable>(
        _ key: String,
        ttl: TimeInterval? = nil,
        fetch: () async throws -> T
    ) async throws -> T {
        // Check cache
        if let cached: T = read(key) {
            return cached
        }

        // Fetch and store
        let value = try await fetch()
        write(key, value: value, ttl: ttl ?? defaultTTL)
        return value
    }

    // MARK: - Read

    public func read<T>(_ key: String) -> T? {
        lock.lock()
        defer { lock.unlock() }

        guard let entry = storage[key] as? CacheEntry<T> else { return nil }
        if entry.isExpired {
            storage.removeValue(forKey: key)
            return nil
        }
        return entry.value
    }

    // MARK: - Write

    public func write<T>(_ key: String, value: T, ttl: TimeInterval? = nil) {
        lock.lock()
        defer { lock.unlock() }

        let entry = CacheEntry(value: value, timestamp: Date(), ttl: ttl ?? defaultTTL)
        storage[key] = entry
    }

    // MARK: - Invalidate

    public func invalidate(_ key: String) {
        lock.lock()
        defer { lock.unlock() }
        storage.removeValue(forKey: key)
    }

    public func invalidateAll() {
        lock.lock()
        defer { lock.unlock() }
        storage.removeAll()

        OwlsEventBus.shared.post(.cacheCleared)
    }

    // MARK: - Invalidate by Prefix

    public func invalidate(prefix: String) {
        lock.lock()
        defer { lock.unlock() }
        storage.keys.filter { $0.hasPrefix(prefix) }.forEach { storage.removeValue(forKey: $0) }
    }
}
