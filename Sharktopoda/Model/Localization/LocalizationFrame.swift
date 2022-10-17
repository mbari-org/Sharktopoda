//
//  LocalizationFrame.swift
//  Created for Sharktopoda on 10/13/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct LocalizationFrame: Comparable {
  let frameNumber: Int
  
  private(set) var ids: [String]
  
  init(_ localization: Localization, _ frameNumber: Int) {
    self.frameNumber = frameNumber
    ids = [String]()
    ids.append(localization.id)
  }
  
  mutating func add(_ localization: Localization) {
    ids.append(localization.id)
  }
  
  mutating func remove(_ localization: Localization) {
    guard let index = ids.firstIndex(of: localization.id) else { return }
    ids.remove(at: index)
  }
    
  // Comparable
  static func < (lhs: LocalizationFrame, rhs: LocalizationFrame) -> Bool {
    lhs.frameNumber < rhs.frameNumber
  }
  
  
}
