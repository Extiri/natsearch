// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser

// Disables notice and info logs.
var QUIET_MODE = false

@main
struct natsearch: AsyncParsableCommand {
  static let configuration = CommandConfiguration(
          abstract: "A utility for searching using natural language.",
          subcommands: [Search.self],
          defaultSubcommand: Search.self)
}

