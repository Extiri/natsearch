//
//  File.swift
//
//
//  Created by Wiktor Wójcik on 14/07/2024.
//

import Foundation
import ArgumentParser

extension natsearch {
  struct Search: AsyncParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Search in the current directory.")
    
    @Option(help: "Depth of search in current directory.")
    var depth: Int = 3
    
    @Option(help: "Number of code lines per fragment.")
    var splitLength: Int = 3
    
    @Option(help: "Number of results.")
    var resultsNumber: Int = 3
    
    @Flag(name: [.long, .customShort("q")], help: "Hide info and notice logs.")
    var quiet = false

    @Argument(help: "Query in natural language")
    var query: String
    
    mutating func run() async {
     let indexManager = IndexManager()
      let walkingManager = WalkingManager(indexManager: indexManager, splitLength: splitLength)
      
      do {
        try await walkingManager.walkDirectory(url: URL(string: FileManager.default.currentDirectoryPath)!, depth: depth)
      } catch {
        log(error.localizedDescription, role: .error)
      }
      
      let results = await indexManager.search(query: query, nResults: resultsNumber)
      
      print("\n---\n")
      
      for (i, result) in results.enumerated() {
        if i >= resultsNumber {
          break
        }
        
        print("\(i + 1). \(result.fragment.location())")
        print("File path:")
        print(result.fragment.fileURL.path)
        print("Fragment content:")
        print(result.fragment.content)
        print("\n\n\n")
      }
    }
  }
}
