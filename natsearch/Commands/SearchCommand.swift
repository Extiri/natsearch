//
//  File.swift
//
//
//  Created by Wiktor Wójcik on 14/07/2024.
//

import Foundation
import ArgumentParser
import Chalk

extension natsearch {
  struct Search: AsyncParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Search in the current directory.")
    
    @Option(name: [.long, .customShort("d")], help: "Depth of search in current directory.")
    var depth: Int = 3
    
    @Option(name: [.long, .customShort("s")], help: "Number of code lines per fragment.")
    var splitLength: Int = 5
    
    @Option(name: [.long, .customShort("n")], help: "Number of results.")
    var resultsNumber: Int = 3
    
    @Flag(name: [.long], help: "Print output as JSON")
    var json: Bool = false
    
    @Flag(name: [.long, .customShort("q")], help: "Hide info and notice logs.")
    var quiet = false
    
    @Argument(help: "Query in natural language")
    var query: String
    
    mutating func run() async {
      QUIET_MODE = quiet
      
      let indexManager = IndexManager()
      let walkingManager = WalkingManager(indexManager: indexManager, splitLength: splitLength)
      
      do {
        try await walkingManager.walkDirectory(url: URL(string: FileManager.default.currentDirectoryPath)!, depth: depth)
      } catch {
        log(error.localizedDescription, role: .error)
      }
      
      let results = await indexManager.search(query: query, nResults: resultsNumber)
      
      if json {
        let jsonResults = results.map(JSONResult.fromResult)
        let jsonEncoder = JSONEncoder()
        
        do {
          let data = try jsonEncoder.encode(jsonResults)
          let asString = String(data: data, encoding: .utf8)!
          print(asString)
        } catch {
          log(error.localizedDescription, role: .error)
        }
      } else {
        print("Results:\n---------------------------------")
        
        for (i, result) in results.enumerated() {
          if i >= resultsNumber {
            break
          }
          
          print("\(i + 1). \(result.fragment.location(), color: .green)")
          print("\("File path", color: .yellow)")
          print("\(result.fragment.fileURL.path)\n")
          print("\("Fragment content", color: .yellow)")
          print(result.fragment.content)
          print("---------------------------------")
        }
      }
    }
  }
}
