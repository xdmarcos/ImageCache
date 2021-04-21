// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "ImageCache",
  platforms: [
    .macOS(.v11), .iOS(.v13), .tvOS(.v13),
  ],
  products: [
    .library(
      name: "ImageCache",
      targets: ["ImageCache"]
    ),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "ImageCache",
      dependencies: []
    ),
    .testTarget(
      name: "ImageCacheTests",
      dependencies: ["ImageCache"]
    ),
  ]
)
