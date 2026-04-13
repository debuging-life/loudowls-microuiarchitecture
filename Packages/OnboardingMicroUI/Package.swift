// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "OnboardingMicroUI",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "OnboardingMicroUI", targets: ["OnboardingMicroUI"])
    ],
    dependencies: [
        .package(path: "../MicroUICore")
    ],
    targets: [
        .target(
            name: "OnboardingMicroUI",
            dependencies: ["MicroUICore"]
        )
    ]
)
