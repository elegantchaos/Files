// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "URLExtensions",
    products: [
        .library(
            name: "URLExtensions",
            targets: ["URLExtensions"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "URLExtensions",
            dependencies: []),
        .testTarget(
            name: "URLExtensionsTests",
            dependencies: ["URLExtensions"]),
    ]
)
