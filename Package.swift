// swift-tools-version:5.7
//
//  Package.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataContracts
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "DNSDataContracts",
    platforms: [
        .iOS(.v16),
        .tvOS(.v16),
        .macCatalyst(.v16),
        .macOS(.v13),
        .watchOS(.v9),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DNSDataContracts",
            type: .static,
            targets: ["DNSDataContracts"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/DoubleNode/DNSCore.git", .upToNextMajor(from: "1.12.1")),
        .package(url: "https://github.com/DoubleNode/DNSDataTypes.git", .upToNextMajor(from: "1.12.0")),
        .package(url: "https://github.com/DoubleNode/DNSError.git", .upToNextMajor(from: "1.12.0")),
//        .package(path: "../DNSCore"),
//        .package(path: "../DNSDataTypes"),
//        .package(path: "../DNSError"),
//        .package(url: "https://github.com/peek-travel/swift-currency.git", .upToNextMajor(from: "1.1.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DNSDataContracts",
            dependencies: [
                "DNSCore", "DNSDataTypes", "DNSError",
//                .product(name: "Currency", package: "swift-currency"),
            ]),
        .testTarget(
            name: "DNSDataContractsTests",
            dependencies: ["DNSCore", "DNSDataContracts", "DNSDataTypes"]),
    ],
    swiftLanguageVersions: [.v5]
)
