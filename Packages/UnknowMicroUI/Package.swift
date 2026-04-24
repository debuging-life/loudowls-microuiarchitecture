// swift-tools-version: 5.9
// UnknowMicroUI — Created by Pardip Bhatti <pardipbhatti28@gmail.com> on 2026-04-24

import PackageDescription

let package = Package(
    name: "UnknowMicroUI",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "UnknowMicroUI", targets: ["UnknowMicroUI"])
    ],
    dependencies: [
        .package(path: "../MicroUICore")
    ],
    targets: [
        .target(
            name: "UnknowMicroUI",
            dependencies: ["MicroUICore"]
        ),
        .testTarget(
            name: "UnknowMicroUITests",
            dependencies: ["UnknowMicroUI"]
        )
    ]
)