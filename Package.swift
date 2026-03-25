// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-bit-pack-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "Bit Pack Primitives",
            targets: ["Bit Pack Primitives"]
        ),
        .library(
            name: "Bit Pack Primitives Test Support",
            targets: ["Bit Pack Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(path: "../swift-bit-primitives"),
        .package(path: "../swift-bit-index-primitives"),
    ],
    targets: [
        .target(
            name: "Bit Pack Primitives",
            dependencies: [
                .product(name: "Bit Primitives", package: "swift-bit-primitives"),
                .product(name: "Bit Index Primitives", package: "swift-bit-index-primitives"),
            ]
        ),
        .target(
            name: "Bit Pack Primitives Test Support",
            dependencies: [
                "Bit Pack Primitives",
                .product(name: "Bit Index Primitives Test Support", package: "swift-bit-index-primitives"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Bit Pack Primitives Tests",
            dependencies: [
                "Bit Pack Primitives",
                "Bit Pack Primitives Test Support",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
