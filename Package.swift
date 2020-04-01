// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Files",
    products: [
        .library(
            name: "Files",
            targets: ["Files"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Files",
            dependencies: []),
        .testTarget(
            name: "FilesTests",
            dependencies: ["Files"]),
    ]
)
