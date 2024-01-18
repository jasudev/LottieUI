// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LottieUI",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LottieUI",
            targets: ["LottieUI"]),
    ],
    dependencies: [
        .package(name: "Lottie", url: "https://github.com/oversoul-love/lottie-spm.git", .branch("cal--visionOS"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LottieUI",
            dependencies: ["Lottie"]),
        .testTarget(
            name: "LottieUITests",
            dependencies: ["LottieUI"]),
    ]
)
