// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Files",
    platforms: [
        .macOS(.v10_13), .iOS(.v10), .tvOS(.v10), .watchOS(.v6)
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
        .package(url: "https://github.com/elegantchaos/XCTestExtensions.git", from: "1.4.2")
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
