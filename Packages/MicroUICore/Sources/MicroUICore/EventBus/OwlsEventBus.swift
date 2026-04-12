import Foundation

// MARK: - Event

public struct OwlsEvent: Sendable {
    public let name: String
    public let data: [String: String]

    public init(_ name: String, data: [String: String] = [:]) {
        self.name = name
        self.data = data
    }

    // MARK: - Common Events

    public static let userLoggedIn = OwlsEvent("user.logged_in")
    public static let userLoggedOut = OwlsEvent("user.logged_out")
    public static let tokenRefreshed = OwlsEvent("token.refreshed")
    public static let languageChanged = OwlsEvent("language.changed")
    public static let themeChanged = OwlsEvent("theme.changed")
    public static let networkStatusChanged = OwlsEvent("network.status_changed")
    public static let cacheCleared = OwlsEvent("cache.cleared")
}

// MARK: - Event Bus

public final class OwlsEventBus: @unchecked Sendable {

    public static let shared = OwlsEventBus()

    private var listeners: [String: [(OwlsEvent) -> Void]] = [:]
    private let lock = NSLock()

    private init() {}

    // MARK: - Subscribe

    @discardableResult
    public func on(_ eventName: String, handler: @escaping @Sendable (OwlsEvent) -> Void) -> OwlsEventSubscription {
        lock.lock()
        defer { lock.unlock() }

        if listeners[eventName] == nil {
            listeners[eventName] = []
        }
        let index = listeners[eventName]?.count ?? 0
        listeners[eventName]?.append(handler)

        return OwlsEventSubscription(eventName: eventName, index: index, bus: self)
    }

    // MARK: - Post

    public func post(_ event: OwlsEvent) {
        lock.lock()
        let handlers = listeners[event.name] ?? []
        lock.unlock()

        #if DEBUG
        print("[EventBus] \(event.name) → \(handlers.count) listener(s)")
        #endif

        for handler in handlers {
            handler(event)
        }
    }

    // MARK: - Remove

    func removeListener(eventName: String, index: Int) {
        lock.lock()
        defer { lock.unlock() }

        guard var eventListeners = listeners[eventName], index < eventListeners.count else { return }
        eventListeners.remove(at: index)
        listeners[eventName] = eventListeners
    }

    // MARK: - Remove All

    public func removeAll(for eventName: String) {
        lock.lock()
        defer { lock.unlock() }
        listeners[eventName] = nil
    }
}

// MARK: - Subscription (for cleanup)

public final class OwlsEventSubscription: Sendable {
    private let eventName: String
    private let index: Int
    private let bus: OwlsEventBus

    init(eventName: String, index: Int, bus: OwlsEventBus) {
        self.eventName = eventName
        self.index = index
        self.bus = bus
    }

    public func cancel() {
        bus.removeListener(eventName: eventName, index: index)
    }
}
