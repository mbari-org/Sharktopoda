//
//  LocalizationFrame.swift
//  Created for Sharktopoda on 10/13/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct LocalizationFrame: Comparable {
  let frameNumber: Int
  
  var id: String? = nil
  var ids: [String]? = nil
  
  init(using localization: Localization, frameDuration: Int) {
    id = localization.id
    frameNumber = LocalizationSet.frameNumber(elapsedTime: localization.elapsedTime,
                                              frameDuration: frameDuration)
  }
  
  mutating func add(_ localization: Localization) {
    if let id = id {
      ids = [id, localization.id]
      self.id = nil
    } else {
      ids!.append(localization.id)
    }
  }
  
  mutating func remove(_ localization: Localization) {
    if let _ = id {
      self.id = nil
    } else {
      guard let index = ids!.firstIndex(of: localization.id) else { return }
      ids!.remove(at: index)
      if ids?.count == 1 {
        self.id = ids![0]
        ids = nil
      }
    }
  }
  
  // Comparable
  static func < (lhs: LocalizationFrame, rhs: LocalizationFrame) -> Bool {
    lhs.frameNumber < rhs.frameNumber
  }
}
