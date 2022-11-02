// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "codegen",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax", branch: "main"),
    ],
    targets: [
        .executableTarget(
            name: "codegen",
            dependencies: [.product(name: "SwiftSyntaxBuilder", package: "swift-syntax")]
        ),
    ]
)
