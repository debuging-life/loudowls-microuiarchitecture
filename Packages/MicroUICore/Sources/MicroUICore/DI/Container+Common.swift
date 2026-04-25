import Factory
import SwiftUI

// MARK: - Tile Builders
// Small embeddable widgets that other modules can drop into their UI.

extension Container {
    public var homeTileBuilder: Factory<MicroUITileBuilder?> { promised() }
    public var profileTileBuilder: Factory<MicroUITileBuilder?> { promised() }
    public var authTileBuilder: Factory<MicroUITileBuilder?> { promised() }
    public var onboardingTileBuilder: Factory<MicroUITileBuilder?> { promised() }
    public var settingsTileBuilder: Factory<MicroUITileBuilder?> { promised() }
    public var favoritescreenTileBuilder: Factory<MicroUITileBuilder?> { promised() }
    public var owlscreenTileBuilder: Factory<MicroUITileBuilder?> { promised() }
    public var owlaboutTileBuilder: Factory<MicroUITileBuilder?> { promised() }
}

// MARK: - Screen Builders
// Full screens presented via fullScreenCover or pushed onto NavigationStack.

extension Container {
    public var homeScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
    public var profileScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
    public var authScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
    public var onboardingScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
    public var settingsScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
    public var favoritescreenScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
    public var owlscreenScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
    public var owlaboutScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
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

    public var favoritescreenNavigationCoordinator: Factory<OwlsNavigationCoordinator> {
        self { OwlsNavigationCoordinator() }.scope(.shared)
    }

    public var owlscreenNavigationCoordinator: Factory<OwlsNavigationCoordinator> {
        self { OwlsNavigationCoordinator() }.scope(.shared)
    }

    public var owlaboutNavigationCoordinator: Factory<OwlsNavigationCoordinator> {
        self { OwlsNavigationCoordinator() }.scope(.shared)
    }
}

// MARK: - Auth

extension Container {
    public var authTokenProvider: Factory<AuthTokenProvider?> { self { nil } }
}
