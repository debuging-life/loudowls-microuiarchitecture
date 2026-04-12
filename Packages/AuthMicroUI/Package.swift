// swift-tools-version: 5.9
// AuthMicroUI — Created by Pardip Bhatti <pardip@example.com> on 2026-04-12

import PackageDescription

let package = Package(
    name: "AuthMicroUI",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "AuthMicroUI", targets: ["AuthMicroUI"])
    ],
    dependencies: [
        .package(path: "../MicroUICore")
    ],
    targets: [
        .target(
            name: "AuthMicroUI",
            dependencies: ["MicroUICore"]
        )
    ]
)
