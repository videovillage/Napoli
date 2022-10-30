// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "NAPITests",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(name: "NAPITests", type: .dynamic, targets: ["NAPITests"]),
    ],
    dependencies: [
        .package(path: "../"),
    ],
    targets: [
        .target(name: "Trampoline",
                dependencies: [.product(name: "NAPIC", package: "swift-napi-bindings")]),
        .target(name: "NAPITests",
                dependencies: ["Trampoline",
                               .product(name: "NAPI", package: "swift-napi-bindings")]),
    ]
)
