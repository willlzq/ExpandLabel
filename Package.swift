// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
// 当前版本: 1.1.0 - 添加展开/收起动画功能

import PackageDescription

let package = Package(
    name: "ExpandLabel",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ExpandLabel",
            targets: ["ExpandLabel"]),
    ],
    dependencies: [],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ExpandLabel"),
        .testTarget(
            name: "ExpandLabelTests",
            dependencies: ["ExpandLabel"]
        ),
    ]
)
