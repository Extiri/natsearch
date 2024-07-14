//
//  SemanticsManager.swift
//  
//
//  Created by Wiktor Wójcik on 13/07/2024.
//

import Foundation
import SimilaritySearchKit
import SimilaritySearchKitMiniLMAll

class SemanticsManager {
  typealias Embedding = [Float]
  
  static func calculateEmbedding(content: String) async -> Embedding {
    let embeddings = MiniLMEmbeddings()
    let embedding = await embeddings.encode(sentence: content) ?? []
    return embedding
  }
  
  static func calculateSimilarity(embg1: Embedding, embg2: Embedding) -> Float {
    let similarity = CosineSimilarity().distance(between: embg1, and: embg2)
    return similarity
  }
}

