// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AIWorkoutCoach",
    platforms: [
        .iOS(.v16),
        .macOS(.v12)
    ],
    products: [
        .library(name: "AIWorkoutCoach", targets: ["AIWorkoutCoach"])
    ],
    targets: [
        .target(name: "AIWorkoutCoach"),
        .testTarget(
            name: "AIWorkoutCoachTests",
            dependencies: ["AIWorkoutCoach"]
        )
    ]
)
