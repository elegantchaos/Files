// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Files",
    products: [
        .library(
            name: "Files",
            targets: ["Files"]),
    .library(
        name: "FilesKit",
        targets: ["FilesKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Files",
            dependencies: []),
        .target(
            name: "FilesKit",
            dependencies: ["Files"]),
        .testTarget(
            name: "FilesTests",
            dependencies: ["Files"]),
    ]
)
