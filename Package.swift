// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TicTacToe",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TicTacToe",
            targets: ["TicTacToe"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
            from: "11.0.0"
        )
    ],
    targets: [
        .target(
            name: "TicTacToe",
            dependencies: [
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads")
            ]),
        .testTarget(
            name: "TicTacToeTests",
            dependencies: ["TicTacToe"]),
    ]
)