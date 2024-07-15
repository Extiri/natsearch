//
//  Fragment.swift
//  
//
//  Created by Wiktor Wójcik on 13/07/2024.
//

import Foundation

struct Fragment {
  var fileURL: URL
  var beginningLine: Int
  var endingLine: Int
  var content: String
  var embedding: SemanticsManager.Embedding? = nil
  
  func location() -> String {
    // At this moment it shows only the filename and extension, which may be confusing in case there are many files with the same name, but for now that should be enough
    "[\(fileURL.lastPathComponent)](\(beginningLine)...\(endingLine))"
  }
}
