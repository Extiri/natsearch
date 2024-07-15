//
//  File.swift
//  
//
//  Created by Wiktor Wójcik on 13/07/2024.
//

import Foundation

extension FileManager {
  func isDirectory(path: String) -> Bool {
    var isDirectory: ObjCBool = false
    self.fileExists(atPath: path, isDirectory: &isDirectory)
    return isDirectory.boolValue
  }
}

class WalkingManager {
  let indexManager: IndexManager
  var splitLength: Int
  
  var fileBlocklist = [".DS_Store", "LICENSE"] // Both should probably be optional/configurable
  var extensionBlocklist = ["pbxproj", "xcworkspace", "xcodeproj", "resolved", "plist", "storyboard", "xcbkptlist"]
  
  func isBlocked(_ url: URL) -> Bool {
    if fileBlocklist.contains(url.lastPathComponent) || url.lastPathComponent.hasPrefix(".") {
      return true
    }
    
    for blockedExtension in extensionBlocklist {
      if url.lastPathComponent.hasSuffix(blockedExtension) {
        return true
      }
    }
    
    return false
  }

  init(indexManager: IndexManager, splitLength: Int) {
    self.indexManager = indexManager
    self.splitLength = splitLength
  }
  
  func walkDirectory(url: URL, depth: Int = 5) async throws {
    log("Checking directory [\(url.lastPathComponent)]", role: .info)
    
    let contentList = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
    
    for item in contentList {
      if isBlocked(item) { continue }
      
      if FileManager.default.isDirectory(path: item.path) {
        try await walkDirectory(url: item)
      } else {
        try await analyseFile(url: item)
      }
    }
  }
  
  func analyseFile(url: URL) async throws {
    log("Parsing file [\(url.lastPathComponent)]", role: .info)
    guard let contentsData = FileManager.default.contents(atPath: url.path) else {
      log("File \(url) has no data.", role: .warning)
      return
    }
    
    guard let contents = String(data: contentsData, encoding: .utf8) else {
      // Most likely not a text file.
      return
    }
    
    var fragments = [Fragment]()
    
    var currentBeginningLine = 1
    var currentLine = 1
    var currentContent = ""
    
    for (i, char) in contents.enumerated() {
      currentContent.append(char)
      
      if char == "\n" || i == contents.count - 1 {
        if currentLine % splitLength == 0 {
          let fragment = Fragment(fileURL: url, beginningLine: currentBeginningLine, endingLine: currentLine, content: currentContent)
          fragments.append(fragment)
          currentLine += 1
          currentBeginningLine = currentLine
          currentContent = ""
        } else {
          currentLine += 1
        }
      }
    }
    
    for fragment in fragments {
      await indexManager.addFragment(fragment)
      log("Added fragment \(fragment.location())", role: .info)
    }
  }
}
