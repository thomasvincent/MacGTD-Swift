// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "MacGTD",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "MacGTD",
            targets: ["MacGTD"]),
        .executable(
            name: "GTDTool",
            targets: ["GTDTool"])
    ],
    dependencies: [
        // Dependencies go here
    ],
    targets: [
        .target(
            name: "MacGTD",
            dependencies: []),
        .executableTarget(
            name: "GTDTool",
            dependencies: ["MacGTD"]),
        .testTarget(
            name: "MacGTDTests",
            dependencies: ["MacGTD"]),
    ],
    swiftLanguageVersions: [.v5]
)