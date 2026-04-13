import SwiftUI
import MicroUICore
import Factory

// MARK: - Auth State (observable, listens to event bus)

@Observable
final class AppAuthState {
    var isLoggedIn = false

    init() {
        // Check if session was restored from Keychain at boot
        isLoggedIn = Container.shared.authTokenProvider() != nil
            || OwlsKeychain.shared.exists(OwlsKeychain.Keys.accessToken)

        OwlsEventBus.shared.on("user.logged_in") { [weak self] _ in
            DispatchQueue.main.async { self?.isLoggedIn = true }
        }

        OwlsEventBus.shared.on("user.logged_out") { [weak self] _ in
            DispatchQueue.main.async { self?.isLoggedIn = false }
        }
    }
}

// MARK: - Root View (Auth Gate)

struct RootView: View {

    @State private var authState = AppAuthState()
    @Injected(\.authScreenBuilder) private var authScreenBuilder
    @Injected(\.homeScreenBuilder) private var homeScreenBuilder
    @Injected(\.profileScreenBuilder) private var profileScreenBuilder

    var body: some View {
        Group {
            if authState.isLoggedIn {
                mainApp
            } else {
                authScreen
            }
        }
    }

    // MARK: - Auth Screen

    @ViewBuilder
    private var authScreen: some View {
        if let builder = authScreenBuilder {
            builder.buildScreen()
        } else {
            ContentUnavailableView("Auth Unavailable", systemImage: "lock.slash")
        }
    }

    // MARK: - Main App

    private var mainApp: some View {
        TabView {
            Tab("Stories", systemImage: "book.fill") {
                homeTab
            }

            Tab("Profile", systemImage: "person.fill") {
                profileTab
            }
        }
    }

    // MARK: - Tabs

    @ViewBuilder
    private var homeTab: some View {
        if let builder = homeScreenBuilder {
            builder.buildScreen()
        } else {
            ContentUnavailableView("Home Unavailable", systemImage: "house.slash")
        }
    }

    @ViewBuilder
    private var profileTab: some View {
        if let builder = profileScreenBuilder {
            builder.buildScreen()
        } else {
            ContentUnavailableView("Profile Unavailable", systemImage: "person.crop.circle.badge.xmark")
        }
    }
}
