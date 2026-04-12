// swift-tools-version: 5.9
// StoryLibraryMicroUI — Created by Test <test@test.com> on 2026-04-12

import PackageDescription

let package = Package(
    name: "StoryLibraryMicroUI",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "StoryLibraryMicroUI", targets: ["StoryLibraryMicroUI"])
    ],
    dependencies: [
        .package(path: "../MicroUICore")
    ],
    targets: [
        .target(
            name: "StoryLibraryMicroUI",
            dependencies: ["MicroUICore"]
        )
    ]
)
