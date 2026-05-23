// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "IntlJpeg",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
        .tvOS(.v17),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "IntlJpeg", targets: ["IntlJpeg"]),
    ],
    dependencies: [
        .package(url: "https://github.com/avgx/IntlWireFormat", from: "1.0.0"),
        .package(url: "https://github.com/avgx/RequestResponse", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "IntlJpeg",
            dependencies: [
                .product(name: "IntlWireFormat", package: "IntlWireFormat"),
                .product(name: "RequestResponse", package: "RequestResponse"),
            ]
        ),
        .testTarget(
            name: "IntlJpegTests",
            dependencies: ["IntlJpeg"]
        ),
    ]
)
