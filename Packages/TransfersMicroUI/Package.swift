// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "TransfersMicroUI",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "TransfersMicroUI", targets: ["TransfersMicroUI"])
    ],
    dependencies: [
        .package(path: "../MicroUICore")
    ],
    targets: [
        .target(
            name: "TransfersMicroUI",
            dependencies: ["MicroUICore"]
        )
    ]
)
