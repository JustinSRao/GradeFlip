// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "GradeFlip",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(name: "GradeFlipDomain", targets: ["GradeFlipDomain"]),
        .library(name: "GradeFlipStorage", targets: ["GradeFlipStorage"]),
        .library(name: "GradeFlipBilling", targets: ["GradeFlipBilling"]),
        .library(name: "GradeFlipOnline", targets: ["GradeFlipOnline"]),
        .library(name: "GradeFlipAI", targets: ["GradeFlipAI"]),
    ],
    targets: [
        .target(
            name: "GradeFlipDomain",
            path: "packages/GradeFlipDomain/Sources/GradeFlipDomain"
        ),
        .target(
            name: "GradeFlipStorage",
            dependencies: ["GradeFlipDomain"],
            path: "packages/GradeFlipStorage/Sources/GradeFlipStorage"
        ),
        .target(
            name: "GradeFlipBilling",
            dependencies: ["GradeFlipDomain"],
            path: "packages/GradeFlipBilling/Sources/GradeFlipBilling"
        ),
        .target(
            name: "GradeFlipOnline",
            dependencies: ["GradeFlipDomain", "GradeFlipBilling"],
            path: "packages/GradeFlipOnline/Sources/GradeFlipOnline"
        ),
        .target(
            name: "GradeFlipAI",
            dependencies: ["GradeFlipDomain", "GradeFlipBilling"],
            path: "packages/GradeFlipAI/Sources/GradeFlipAI"
        ),
        .testTarget(
            name: "GradeFlipDomainTests",
            dependencies: ["GradeFlipDomain"],
            path: "packages/GradeFlipDomain/Tests/GradeFlipDomainTests"
        ),
        .testTarget(
            name: "GradeFlipBillingTests",
            dependencies: ["GradeFlipBilling"],
            path: "packages/GradeFlipBilling/Tests/GradeFlipBillingTests"
        ),
        .testTarget(
            name: "GradeFlipStorageTests",
            dependencies: ["GradeFlipStorage"],
            path: "packages/GradeFlipStorage/Tests/GradeFlipStorageTests"
        ),
    ]
)
