//
//  LocalizationSet.swift
//  Created for Sharktopoda on 10/6/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

class LocalizationSet<T: Localization>: Sequence {
  private let set = NSMutableOrderedSet()
  init() {}
  
  func makeIterator() -> NSFastEnumerationIterator {
    return set.makeIterator()
  }
  
  func add(_ element: T) {
    set.add(element)
  }
  
  func remove(_ element: T) {
    set.remove(element)
  }
}
