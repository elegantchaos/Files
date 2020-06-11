// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Files",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .library(
            name: "Files",
            targets: ["Files"]),
    .library(
        name: "FilesKit",
        targets: ["FilesKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/elegantchaos/XCTestExtensions", from: "1.1.2")
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
            dependencies: ["Files", "XCTestExtensions"]),
    ]
)
