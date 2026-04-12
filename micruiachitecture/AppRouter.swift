import SwiftUI
import MicroUICore
import Factory

// MARK: - App-Level Route

enum AppRoute: Hashable, Identifiable {
    case home
    case profile

    var id: Self { self }
}

// MARK: - App Router

@Observable
final class AppRouter: @unchecked Sendable {

    var presentedRoute: AppRoute?

    nonisolated init() {}

    func present(_ route: AppRoute) {
        presentedRoute = route
    }

    func dismiss() {
        presentedRoute = nil
    }
}

// MARK: - Container Registration

extension Container {
    var appRouter: Factory<AppRouter> {
        self { AppRouter() }.scope(.shared)
    }
}
