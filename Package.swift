// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "DataSource",
	platforms: [
		.macOS(.v10_15), .iOS(.v13), .tvOS(.v13)
	],
	products: [
		.library(
			name: "DataSource",
			targets: ["DataSource"]
		)
	],
	targets: [
		.target(
			name: "DataSource",
			path: "DataSource",
			exclude: ["Info.plist"],
			linkerSettings: [
				.linkedFramework("Foundation"),
				.linkedFramework("UIKit", BuildSettingCondition.when(platforms: [.iOS, .tvOS])),
				.linkedFramework("AppKit", BuildSettingCondition.when(platforms: [.macOS]))
			]
		)
	]
)
