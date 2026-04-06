// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Tribunal",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "Tribunal",
            path: "Sources/Tribunal"
        ),
        .testTarget(
            name: "TribunalTests",
            dependencies: ["Tribunal"],
            path: "Tests/TribunalTests"
        )
    ]
)
