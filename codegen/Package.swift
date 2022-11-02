// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "codegen",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(name: "codegen"),
    ]
)
