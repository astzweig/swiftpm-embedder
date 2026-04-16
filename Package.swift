// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "Embedder",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        .plugin(
            name: "Embedder",
            targets: ["Embedder"]
        )
    ],
    targets: [
        .plugin(
            name: "Embedder",
            capability: .buildTool(),
            dependencies: [
                .target(name: "EmbedderTool")
            ]
        ),
        .executableTarget(
            name: "EmbedderTool",
            path: "Sources/EmbedderTool"
        ),
        .testTarget(
            name: "EmbedderToolTests",
            dependencies: ["EmbedderTool"],
            path: "Tests/EmbedderToolTests"
        )
    ]
)
