// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "FeatureHomeMicroUI",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "FeatureHomeMicroUI", targets: ["FeatureHomeMicroUI"])
    ],
    dependencies: [
        .package(path: "../MicroUICore")
    ],
    targets: [
        .target(
            name: "FeatureHomeMicroUI",
            dependencies: ["MicroUICore"]
        )
    ]
)
