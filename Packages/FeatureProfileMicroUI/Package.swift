// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "FeatureProfileMicroUI",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "FeatureProfileMicroUI", targets: ["FeatureProfileMicroUI"])
    ],
    dependencies: [
        .package(path: "../MicroUICore")
    ],
    targets: [
        .target(
            name: "FeatureProfileMicroUI",
            dependencies: ["MicroUICore"]
        )
    ]
)
