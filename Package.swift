// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "NAPI",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(name: "NAPI", type: .static, targets: ["NAPI"]),
        .library(name: "NAPIC", type: .static, targets: ["NAPIC"]),
    ],
    targets: [
        .target(name: "NAPI", dependencies: ["NAPIC"]),
        .target(name: "NAPIC", publicHeadersPath: "include"),
    ]
)
