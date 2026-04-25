// swift-tools-version: 5.9
// FavoriteScreenMicroUI — Created by Pardip Bhatti <contactme@pardipbhatti.pro> on 2026-04-12

import PackageDescription

let package = Package(
    name: "FavoriteScreenMicroUI",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "FavoriteScreenMicroUI", targets: ["FavoriteScreenMicroUI"])
    ],
    dependencies: [
        .package(path: "../MicroUICore")
    ],
    targets: [
        .target(
            name: "FavoriteScreenMicroUI",
            dependencies: ["MicroUICore"],
            resources: [.process("Mocks/JSON")]
        ),
        .testTarget(
            name: "FavoriteScreenMicroUITests",
            dependencies: ["FavoriteScreenMicroUI"]
        )
    ]
)