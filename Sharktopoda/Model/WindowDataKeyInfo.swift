//
//  VideoWindowKeyInfo.swift
//  Created for Sharktopoda on 11/18/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

extension WindowData: Comparable {

  struct WindowKeyInfo {
    var keyTime: Date = Date()
    var isKey: Bool = false
    
    init(isKey: Bool = false) {
      self.isKey = isKey
    }
    
    static func <(lhs: WindowKeyInfo, rhs: WindowKeyInfo) -> Bool {
      lhs.keyTime < rhs.keyTime
    }
    
    static func ==(lhs: WindowKeyInfo, rhs: WindowKeyInfo) -> Bool {
      lhs.keyTime == rhs.keyTime
    }
  }
  
  static func <(lhs: WindowData, rhs: WindowData) -> Bool {
    lhs.windowKeyInfo < rhs.windowKeyInfo
  }
  
  static func ==(lhs: WindowData, rhs: WindowData) -> Bool {
    lhs.windowKeyInfo == rhs.windowKeyInfo
  }
  
}
