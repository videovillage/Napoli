// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "NapoliTests",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(name: "NapoliTests", type: .dynamic, targets: ["NapoliTests"]),
    ],
    dependencies: [
        .package(path: "../"),
    ],
    targets: [
        .target(name: "Trampoline",
                dependencies: [.product(name: "NAPIC", package: "Napoli")]),
        .target(name: "NapoliTests",
                dependencies: ["Trampoline",
                               .product(name: "Napoli", package: "Napoli")]),
    ]
)
