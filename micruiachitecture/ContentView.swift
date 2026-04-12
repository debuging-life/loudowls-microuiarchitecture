import SwiftUI
import MicroUICore
import Factory

// MARK: - Root View

struct RootView: View {

    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                DashboardView()
            }

            Tab("Profile", systemImage: "person.fill") {
                ProfileTabView()
            }
        }
    }
}

// MARK: - Dashboard Tab

private struct DashboardView: View {

    @Injected(\.homeScreenBuilder) private var homeScreenBuilder
    @Injected(\.profileScreenBuilder) private var profileScreenBuilder
    @Injected(\.authScreenBuilder) private var authScreenBuilder
    @Injected(\.homeNavigationCoordinator) private var homeCoordinator
    @Injected(\.profileNavigationCoordinator) private var profileCoordinator
    @Injected(\.authNavigationCoordinator) private var authCoordinator

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: OwlsSpacing.lg) {
                    // MARK: Tiles
                    TileGrid()

                    Spacer()
                }
                .padding(OwlsSpacing.lg)
            }
            .navigationTitle("Dashboard")
            .fullScreenCover(isPresented: Bindable(homeCoordinator).isPresented) {
                homeScreenBuilder?.buildScreen()
            }
            .fullScreenCover(isPresented: Bindable(profileCoordinator).isPresented) {
                profileScreenBuilder?.buildScreen()
            }
            .fullScreenCover(isPresented: Bindable(authCoordinator).isPresented) {
                authScreenBuilder?.buildScreen()
            }
        }
    }
}

// MARK: - Profile Tab (direct screen, no coordinator)

private struct ProfileTabView: View {

    @Injected(\.profileScreenBuilder) private var profileScreenBuilder

    var body: some View {
        if let builder = profileScreenBuilder {
            builder.buildScreen()
        } else {
            ContentUnavailableView(
                "Profile Unavailable",
                systemImage: "person.crop.circle.badge.xmark"
            )
        }
    }
}

// MARK: - Tile Grid

private struct TileGrid: View {

    @Injected(\.homeTileBuilder) private var homeTileBuilder
    @Injected(\.profileTileBuilder) private var profileTileBuilder
    @Injected(\.authTileBuilder) private var authTileBuilder

    private var tiles: [AnyView] {
        [authTileBuilder, homeTileBuilder, profileTileBuilder]
            .compactMap { $0?.buildTile() }
    }

    var body: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: OwlsSpacing.lg
        ) {
            ForEach(Array(tiles.enumerated()), id: \.offset) { _, tile in
                tile
            }
        }
    }
}
