// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "NAPI",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(name: "NAPI", targets: ["NAPI"]),
        .library(name: "NAPIC", targets: ["NAPIC"]),
    ],
    targets: [
        .target(name: "NAPI", dependencies: ["NAPIC"]),
        .target(name: "NAPIC", publicHeadersPath: "include"),
    ]
)
