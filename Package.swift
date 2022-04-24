// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AuthorizedZone",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AuthorizedZone",
            targets: ["AuthorizedZone"]),
    ],
    dependencies: [
        .package(name: "Module", path: "/Users/armancarhcan/Desktop/Module"),
        .package(name: "DesignSystem", path: "/Users/armancarhcan/Desktop/DesignSystem"),
        .package(name: "Settings", path: "/Users/armancarhcan/Desktop/Settings"),
        .package(name: "Managers", path: "/Users/armancarhcan/Desktop/Managers"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AuthorizedZone",
            dependencies: [.product(name: "Module", package: "Module"),
                           .product(name: "DesignSystem", package: "DesignSystem"),
                           .product(name: "Managers", package: "Managers"),
                           .product(name: "Swinject", package: "Swinject"),
                           .product(name: "Settings", package: "Settings")]),
    ]
)
