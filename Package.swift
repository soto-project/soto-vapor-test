// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "aws-vapor-test",
    platforms: [
       .macOS(.v10_15)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(name: "AWSSDKSwift", url: "https://github.com/soto-project/soto.git", from: "4.0.0")
    ],
    targets: [
        .target(name: "App", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "S3", package: "AWSSDKSwift")
        ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
