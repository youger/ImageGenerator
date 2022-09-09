// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ImageGenerator",
    platforms: [
        .macOS(.v10_11),
        .iOS(.v9),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ImageGenerator",
            targets: ["ImageGenerator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImage", from: "5.13.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ImageGenerator",
            dependencies: [
                .product(
                    name: "SDWebImage",
                    package: "SDWebImage",
                    condition: .when(platforms: [.iOS])
                ),
            ],
            path: "Sources/swift"),
        .testTarget(
            name: "ImageGeneratorTests",
            dependencies: ["ImageGenerator"]),
    ]
)
