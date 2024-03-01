// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "Napoli",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(name: "Napoli", targets: ["Napoli"]),
        .library(name: "NAPIC", targets: ["NAPIC"]),
    ],
    targets: [
        .target(name: "Napoli", dependencies: ["NAPIC"]),
        .target(name: "NAPIC", publicHeadersPath: "include"),
    ]
)
