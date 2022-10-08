//
//  LocalizationSet.swift
//  Created for Sharktopoda on 10/6/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct LocalizationSet<T: Localization> {
  private var set = Set<Localization>()
  private var array = Array<Localization>()
  
  init() {}

  mutating func add(_ localization: T) -> Bool {
    let (inserted, _) = set.insert(localization)
    if inserted {
      arrayAdd(localization)
    }
    return inserted
  }
  
  mutating func remove(_ localization: T) {
    if set.remove(localization) != nil {
      arrayRemove(localization)
    }
  }
  
  private mutating func arrayAdd(_ localization: T) {
    if array.isEmpty {
      array.append(localization)
    } else if array.count == 1 {
      if localization < array[0] {
        array.insert(localization, at: 0)
      } else {
        array.append(localization)
      }
    } else if array.last! < localization {
      array.append(localization)
    } else {
      let index = array.binarySearch(for: localization) ?? array.count
      array.insert(localization, at: index)
    }
  }
  
  private mutating func arrayRemove(_ localization: T) {
    guard !array.isEmpty else { return }
    if array.count == 1 {
      guard localization == array[0] else { return }
      array.remove(at: 0)
    } else {
      if let index = array.binarySearch(for: localization) {
        array.remove(at: index)
      } else {
        return
      }
    }
  }
}
