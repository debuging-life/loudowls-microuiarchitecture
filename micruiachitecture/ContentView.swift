import SwiftUI
import MicroUICore
import Factory

// MARK: - Auth State

@Observable
final class AppAuthState {
    var isLoggedIn = false

    init() {
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

// MARK: - Root View

struct RootView: View {

    @State private var authState = AppAuthState()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("owls.settings.darkMode") private var isDarkMode = false

    @Injected(\.authScreenBuilder) private var authScreenBuilder
    @Injected(\.homeScreenBuilder) private var homeScreenBuilder
    @Injected(\.profileScreenBuilder) private var profileScreenBuilder
    @Injected(\.settingsScreenBuilder) private var settingsScreenBuilder
    @Injected(\.onboardingScreenBuilder) private var onboardingScreenBuilder

    var body: some View {
        Group {
            if !hasSeenOnboarding {
                onboardingScreen
            } else if authState.isLoggedIn {
                mainApp
            } else {
                authScreen
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }

    // MARK: - Onboarding

    @ViewBuilder
    private var onboardingScreen: some View {
        if let builder = onboardingScreenBuilder {
            builder.buildScreen()
        } else {
            Color.clear.onAppear { hasSeenOnboarding = true }
        }
    }

    // MARK: - Auth

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

            Tab("Settings", systemImage: "gearshape.fill") {
                settingsTab
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

    @ViewBuilder
    private var settingsTab: some View {
        if let builder = settingsScreenBuilder {
            builder.buildScreen()
        } else {
            ContentUnavailableView("Settings Unavailable", systemImage: "gearshape.slash")
        }
    }
}
