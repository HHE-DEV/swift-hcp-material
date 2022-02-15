// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "swift-hcp-material",
  platforms: [
    .macOS(.v11)
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    .package(url: "https://github.com/pointfreeco/swift-parsing.git", from: "0.1.0")
  ],
  targets: [
    .target(
      name: "CSVClient",
      dependencies: [
        "SharedHelpers",
        "SharedModels",
        .product(name: "Parsing", package: "swift-parsing")
      ]
    ),
    .testTarget(
      name: "CSVTests",
      dependencies: ["CSVClient"],
      resources: [.copy("Resources")]
    ),
    .target(
      name: "PDFClient",
      dependencies: [
        "SharedHelpers",
        "SharedModels",
        .product(name: "Parsing", package: "swift-parsing")
      ],
      linkerSettings: [.linkedFramework("PDFKit")]
    ),
    .testTarget(
      name: "PDFTests",
      dependencies: [
        "SharedHelpers",
        "PDFClient",
        .product(name: "Parsing", package: "swift-parsing")
      ],
      resources: [.copy("Resources")]
    ),
    .target(name: "SharedHelpers"),
    .target(name: "SharedModels"),
    .testTarget(
      name: "SharedModelTests",
      dependencies: ["SharedModels"]
    ),
    .target(
      name: "UpdateClient",
      dependencies: [
        "CSVClient",
        "PDFClient",
        "SharedHelpers",
        "SharedModels"
      ]
    ),
    .testTarget(
      name: "UpdateTests",
      dependencies: [
        "UpdateClient",
        "PDFClient"
      ]
    ),
    .executableTarget(
      name: "hcp-material",
      dependencies: [
        "CSVClient",
        "PDFClient",
        "UpdateClient",
        "SharedHelpers",
        "SharedModels",
        .product(name: "ArgumentParser", package: "swift-argument-parser")
      ],
      linkerSettings: [.linkedFramework("PDFKit")]
    )
  ]
)
