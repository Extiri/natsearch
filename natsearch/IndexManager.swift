//
//  IndexManager.swift
//
//
//  Created by Wiktor Wójcik on 13/07/2024.
//

import Foundation

class IndexManager {
  private var fragments = [Fragment]()
  
  func addFragment(_ fragment: Fragment) async {
    var fragment = fragment
    fragment.embedding = await SemanticsManager.calculateEmbedding(content: fragment.content)
    fragments.append(fragment)
  }
  
  func search(query: String, nResults: Int = 3) async -> [SearchResult] {
    var results = [SearchResult]()
    
    let queryEmbedding = await SemanticsManager.calculateEmbedding(content: query)
    
    for fragment in fragments {
      // In this case, fragment.embedding should never be nil
      let similarity = SemanticsManager.calculateSimilarity(embg1: queryEmbedding, embg2: fragment.embedding!)
      let result = SearchResult(similarity: similarity, fragment: fragment)
      results.append(result)
    }
    
    results = results.sorted(by: { $0.similarity > $1.similarity })
    
    return results
  }
}
