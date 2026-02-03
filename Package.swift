// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-bit-packing-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "Bit Packing Primitives",
            targets: ["Bit Packing Primitives"]
        ),
        .library(
            name: "Bit Packing Primitives Test Support",
            targets: ["Bit Packing Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(path: "../swift-bit-primitives"),
        .package(path: "../swift-bit-index-primitives"),
    ],
    targets: [
        .target(
            name: "Bit Packing Primitives",
            dependencies: [
                .product(name: "Bit Primitives", package: "swift-bit-primitives"),
                .product(name: "Bit Index Primitives", package: "swift-bit-index-primitives"),
            ]
        ),
        .target(
            name: "Bit Packing Primitives Test Support",
            dependencies: [
                "Bit Packing Primitives",
                .product(name: "Bit Index Primitives Test Support", package: "swift-bit-index-primitives"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Bit Packing Primitives Tests",
            dependencies: [
                "Bit Packing Primitives",
                "Bit Packing Primitives Test Support",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let settings: [SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableExperimentalFeature("Lifetimes"),
        .strictMemorySafety()
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + settings
}
