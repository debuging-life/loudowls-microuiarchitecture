import SwiftUI

// MARK: - Stub Tile Builder
//
// Returns a dashed-border placeholder view. Used by Example apps to
// stand in for tile builders from other modules that aren't loaded.

public struct OwlsStubTileBuilder: MicroUITileBuilder {

    private let label: String

    public init(label: String) {
        self.label = label
    }

    public func buildTile() -> AnyView {
        AnyView(StubTileView(label: label))
    }
}

private struct StubTileView: View {
    let label: String

    var body: some View {
        VStack(spacing: OwlsSpacing.xs) {
            Image(systemName: "square.dashed")
                .font(.title2)
                .foregroundStyle(OwlsColor.secondaryLabel)
            Text(label)
                .font(OwlsTypography.caption)
                .foregroundStyle(OwlsColor.secondaryLabel)
            Text("Stub")
                .font(OwlsTypography.footnote)
                .foregroundStyle(OwlsColor.secondaryLabel.opacity(0.6))
        }
        .padding(OwlsSpacing.lg)
        .frame(maxWidth: .infinity)
        .background(OwlsColor.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: OwlsRadius.md))
        .overlay(
            RoundedRectangle(cornerRadius: OwlsRadius.md)
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4]))
                .foregroundStyle(OwlsColor.secondaryLabel.opacity(0.4))
        )
    }
}

// MARK: - Stub Screen Builder

public struct OwlsStubScreenBuilder: MicroUIScreenBuilder {

    private let label: String

    public init(label: String) {
        self.label = label
    }

    public func buildScreen() -> AnyView {
        AnyView(
            OwlsEmptyState(
                icon: "square.dashed",
                title: "\(label) — Stub",
                description: "This module isn't registered in the current Example app. Add it as a dependency and uncomment its registration in ExampleBootstrap.swift to use the real screen."
            )
        )
    }
}

// MARK: - Stub Auth Token Provider

public struct OwlsStubAuthTokenProvider: AuthTokenProvider, Sendable {

    public init() {}

    public var isAuthenticated: Bool { true }

    public func token() async throws -> String {
        "example-sandbox-token"
    }

    public func refreshToken() async throws -> String {
        "example-sandbox-refreshed-token"
    }
}
