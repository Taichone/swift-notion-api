// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-notion-api",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
    ],
    products: [
        .library(
            name: "NotionSwift",
            targets: ["NotionSwift"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NotionSwift",
            dependencies: [],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .testTarget(
            name: "NotionSwiftTests",
            dependencies: ["NotionSwift"],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
    ]
)
