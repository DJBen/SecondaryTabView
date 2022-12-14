// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SecondaryTabView",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "SecondaryTabView",
            targets: ["SecondaryTabView"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SecondaryTabView",
            dependencies: [],
            path: "Sources/",
            exclude: ["Sources/SecondaryTabView.podspec"]),
    ]
)
