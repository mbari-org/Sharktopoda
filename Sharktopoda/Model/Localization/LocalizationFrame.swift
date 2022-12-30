//
//  LocalizationFrame.swift
//  Created for Sharktopoda on 11/2/22.
//
//  Apache License 2.0 — See project LICENSE file
//

struct LocalizationFrame: Comparable {

  let number: Int
  let time: Int
  
  private(set) var ids = [String]()
  
  mutating func add(_ localization: Localization) {
    ids.append(localization.id)
  }
  
  mutating func remove(_ localization: Localization) {
    guard let index = ids.firstIndex(of: localization.id) else { return }
    ids.remove(at: index)
  }
  
  // Comparable
  static func < (lhs: LocalizationFrame, rhs: LocalizationFrame) -> Bool {
    lhs.number < rhs.number
  }
}
