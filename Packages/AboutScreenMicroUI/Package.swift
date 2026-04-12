// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "AboutScreenMicroUI",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "AboutScreenMicroUI", targets: ["AboutScreenMicroUI"])
    ],
    dependencies: [
        .package(path: "../MicroUICore")
    ],
    targets: [
        .target(
            name: "AboutScreenMicroUI",
            dependencies: ["MicroUICore"]
        )
    ]
)
