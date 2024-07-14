//
//  File.swift
//  
//
//  Created by Wiktor Wójcik on 13/07/2024.
//

import Foundation
import Chalk

enum LogRole: Int {
  case info = 0
  case notice = 1
  case warning = 2
  case error = 3
}

extension LogRole: Comparable {
  static func < (lhs: LogRole, rhs: LogRole) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
  
  var text: String {
    switch self {
      case .info: return "\("info", color: .blue)"
      case .notice: return  "\("notice", color: .green)" // Not quire sure what "notice" would mean
      case .warning: return  "\("warning", color: .yellow)"
      case .error: return  "\("error", color: .red)"
    }
  }
}

func log(_ message: String, role: LogRole) {
  if !QUIET_MODE || LogRole.warning <= role {
    print("[\(role.text)] \(message)")
  }
}
