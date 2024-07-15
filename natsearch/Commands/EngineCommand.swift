//
//  ChatCommand.swift
//
//
//  Created by Wiktor Wójcik on 14/07/2024.
//

import Foundation
import ArgumentParser
import Chalk

extension natsearch {
  struct Engine: AsyncParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Continously search through files. It analyses files only once, so it's more efficient for making multiple queries. Type exit to exit.")
    
    @Option(name: [.long, .customShort("d")], help: "Depth of search in current directory.")
    var depth: Int = 3
    
    @Option(name: [.long, .customShort("s")], help: "Number of code lines per fragment.")
    var splitLength: Int = 5
    
    @Option(name: [.long, .customShort("n")], help: "Number of results.")
    var resultsNumber: Int = 3
    
    @Flag(name: [.long, .customShort("q")], help: "Hide info and notice logs.")
    var quiet = false
    
    mutating func run() async {
      QUIET_MODE = quiet
      
      let indexManager = IndexManager()
      let walkingManager = WalkingManager(indexManager: indexManager, splitLength: splitLength)
      
      do {
        try await walkingManager.walkDirectory(url: URL(string: FileManager.default.currentDirectoryPath)!, depth: depth)
      } catch {
        log(error.localizedDescription, role: .error)
      }
      
      print("\n\nType your query into the prompt to search. Type exit to exit.\n\n")
      
      while true {
        print("\(">", color: .cyan) ", terminator: "")
        guard let query = readLine() else { return }
        if query == "exit" { return }
        
        let results = await indexManager.search(query: query, nResults: resultsNumber)
        
        print("Results:")
        
        for (i, result) in results.enumerated() {
          if i >= resultsNumber {
            break
          }
          
          print("---------------------------------")
          
          print("\(i + 1). \(result.fragment.location(), color: .green)")
          print("\("File path", color: .yellow)")
          print("\(result.fragment.fileURL.path)\n")
          print("\("Fragment content", color: .yellow)")
          print(result.fragment.content)
        }
        
        print("\("---------------------------------", color: .red)")
      }
    }
  }
}
