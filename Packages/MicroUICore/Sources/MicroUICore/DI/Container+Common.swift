import Factory
import SwiftUI

// MARK: - Tile Builders

extension Container {
    public var homeTileBuilder: Factory<MicroUITileBuilder?> { promised() }
    public var profileTileBuilder: Factory<MicroUITileBuilder?> { promised() }
    public var aboutscreenTileBuilder: Factory<MicroUITileBuilder?> { promised() }
    public var transfersTileBuilder: Factory<MicroUITileBuilder?> { promised() }
    public var authTileBuilder: Factory<MicroUITileBuilder?> { promised() }
    public var storylibraryTileBuilder: Factory<MicroUITileBuilder?> { promised() }
}

// MARK: - Screen Builders

extension Container {
    public var homeScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
    public var profileScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
    public var aboutscreenScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
    public var transfersScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
    public var authScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
    public var storylibraryScreenBuilder: Factory<MicroUIScreenBuilder?> { promised() }
}

// MARK: - Navigation Coordinators

extension Container {
    public var homeNavigationCoordinator: Factory<OwlsNavigationCoordinator> {
        self { OwlsNavigationCoordinator() }.scope(.shared)
    }
    
    public var profileNavigationCoordinator: Factory<OwlsNavigationCoordinator> {
        self { OwlsNavigationCoordinator() }.scope(.shared)
    }
    
    public var aboutscreenNavigationCoordinator: Factory<OwlsNavigationCoordinator> {
        self { OwlsNavigationCoordinator() }.scope(.shared)
    }

    public var transfersNavigationCoordinator: Factory<OwlsNavigationCoordinator> {
        self { OwlsNavigationCoordinator() }.scope(.shared)
    }

    public var authNavigationCoordinator: Factory<OwlsNavigationCoordinator> {
        self { OwlsNavigationCoordinator() }.scope(.shared)
    }

    public var storylibraryNavigationCoordinator: Factory<OwlsNavigationCoordinator> {
        self { OwlsNavigationCoordinator() }.scope(.shared)
    }
}

// MARK: - Auth

extension Container {
    public var authTokenProvider: Factory<AuthTokenProvider?> { self { nil } }
}
