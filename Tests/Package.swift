// swift-tools-version:5.7

import PackageDescription

let dynamicLinkerSettings: [LinkerSetting] = [.unsafeFlags(["-lnode"], .when(platforms: [.windows])),
                                              .unsafeFlags(["-Xlinker", "-undefined", "-Xlinker", "dynamic_lookup"], .when(platforms: [.macOS, .linux]))]

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
                               .product(name: "Napoli", package: "Napoli")],
                linkerSettings: dynamicLinkerSettings),
    ]
)
