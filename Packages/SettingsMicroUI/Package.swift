// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SettingsMicroUI",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "SettingsMicroUI", targets: ["SettingsMicroUI"])
    ],
    dependencies: [
        .package(path: "../MicroUICore")
    ],
    targets: [
        .target(
            name: "SettingsMicroUI",
            dependencies: ["MicroUICore"]
        )
    ]
)
