// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ObjectMapper",
    products: [
        .library(name: "ObjectMapper", targets: ["ObjectMapper"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ObjectMapper",
            dependencies: [],
            path: "Sources"
        )
    ]
)



