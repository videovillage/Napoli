// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "codegen",
    platforms: [.macOS(.v13)],
    dependencies: [.package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0")],
    targets: [
        .executableTarget(name: "codegen",
                          dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")]),
    ]
)
