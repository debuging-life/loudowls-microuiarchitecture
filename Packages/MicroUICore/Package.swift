// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "MicroUICore",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "MicroUICore", targets: ["MicroUICore"])
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.4.0")
    ],
    targets: [
        .target(
            name: "MicroUICore",
            dependencies: ["Factory"]
        )
    ]
)
