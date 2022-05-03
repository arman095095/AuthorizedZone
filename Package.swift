// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let remoteDependencies: [Package.Dependency] = [
    .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0"),
    .package(url: "https://github.com/arman095095/Managers.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/Module.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/DesignSystem.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/Settings.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/Profile.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/Posts.git", branch: "develop")
]

private let localDependencies: [Package.Dependency] = [
    .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0"),
    .package(path: "/Users/armancarhcan/Desktop/Workdir/Managers"),
    .package(path: "/Users/armancarhcan/Desktop/Workdir/Module"),
    .package(path: "/Users/armancarhcan/Desktop/Workdir/DesignSystem"),
    .package(path: "/Users/armancarhcan/Desktop/Workdir/Settings"),
    .package(path: "/Users/armancarhcan/Desktop/Workdir/Profile"),
    .package(path: "/Users/armancarhcan/Desktop/Workdir/Posts")
]

let isDev = false
private let dependencies = isDev ? localDependencies : remoteDependencies

let package = Package(
    name: "AuthorizedZone",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AuthorizedZone",
            targets: ["AuthorizedZone"]),
    ],
    dependencies: dependencies,
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AuthorizedZone",
            dependencies: [.product(name: "Module", package: "Module"),
                           .product(name: "DesignSystem", package: "DesignSystem"),
                           .product(name: "Managers", package: "Managers"),
                           .product(name: "Swinject", package: "Swinject"),
                           .product(name: "Settings", package: "Settings"),
                           .product(name: "Profile", package: "Profile"),
                           .product(name: "Posts", package: "Posts")]),
    ]
)
