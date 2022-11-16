//
//  VideoViewKeyInfo.swift
//  Created for Sharktopoda on 11/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

extension VideoView {
  struct KeyInfo {
    var keyTime: Date = Date()
    var isKey: Bool = false
    
    static func <(lhs: KeyInfo, rhs: KeyInfo) -> Bool {
      lhs.keyTime < rhs.keyTime
    }
  }
  
  static func <(lhs: VideoView, rhs: VideoView) -> Bool {
    lhs.keyInfo < rhs.keyInfo
  }
}
