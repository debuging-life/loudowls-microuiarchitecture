import Factory
import SwiftUI

// MARK: - Screen Builders

extension Container {
    public var homeScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
    public var profileScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
    public var authScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
    public var onboardingScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
    public var settingsScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
}

// MARK: - Navigation Coordinators

extension Container {
    public var homeNavigationCoordinator: Factory<OwlsNavigationCoordinator> {
        self { OwlsNavigationCoordinator() }.scope(.shared)
    }

    public var profileNavigationCoordinator: Factory<OwlsNavigationCoordinator> {
        self { OwlsNavigationCoordinator() }.scope(.shared)
    }

    public var authNavigationCoordinator: Factory<OwlsNavigationCoordinator> {
        self { OwlsNavigationCoordinator() }.scope(.shared)
    }
}

// MARK: - Auth

extension Container {
    public var authTokenProvider: Factory<AuthTokenProvider?> { self { nil } }
}
