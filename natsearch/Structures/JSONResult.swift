//
//  JSONResult.swift
//  natsearch
//
//  Created by Wiktor Wójcik on 14/07/2024.
//

import Foundation

struct JSONResult: Codable {
  var beginningLine: Int
  var endingLine: Int
  var filepath: String
  var content: String
  
  static func fromResult(_ result: SearchResult) -> JSONResult {
    JSONResult(beginningLine: result.fragment.beginningLine, endingLine: result.fragment.endingLine, filepath: result.fragment.fileURL.path, content: result.fragment.content)
  }
}
