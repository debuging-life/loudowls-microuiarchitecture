// swift-tools-version: 5.9
// OwlAboutMicroUI — Created by Pardip Bhatti <pardipbhatti28@gmail.com> on 2026-04-24

import PackageDescription

let package = Package(
    name: "OwlAboutMicroUI",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "OwlAboutMicroUI", targets: ["OwlAboutMicroUI"])
    ],
    dependencies: [
        .package(path: "../MicroUICore")
    ],
    targets: [
        .target(
            name: "OwlAboutMicroUI",
            dependencies: ["MicroUICore"],
            resources: [.process("Mocks/JSON")]
        ),
        .testTarget(
            name: "OwlAboutMicroUITests",
            dependencies: ["OwlAboutMicroUI"]
        )
    ]
)