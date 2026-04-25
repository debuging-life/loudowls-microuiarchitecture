// swift-tools-version: 5.9
// OwlScreenMicroUI — Created by Pardip Bhatti <pardipbhatti28@gmail.com> on 2026-04-24

import PackageDescription

let package = Package(
    name: "OwlScreenMicroUI",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "OwlScreenMicroUI", targets: ["OwlScreenMicroUI"])
    ],
    dependencies: [
        .package(path: "../MicroUICore")
    ],
    targets: [
        .target(
            name: "OwlScreenMicroUI",
            dependencies: ["MicroUICore"],
            resources: [.process("Mocks/JSON")]
        ),
        .testTarget(
            name: "OwlScreenMicroUITests",
            dependencies: ["OwlScreenMicroUI"]
        )
    ]
)