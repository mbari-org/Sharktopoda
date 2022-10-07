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
    
//  public func objectEnumerator() -> NSEnumerator {
//    array.objectEnumerator()
//  }
  
//  func makeIterator() -> NSFastEnumerationIterator {
//    objectEnumerator().makeIterator()
//  }
  
  mutating func add(_ localization: T) {
    if set.contains(localization) { return }
    
    set.insert(localization)
    
    // CxInc binary search to find index for insertion
    
    array.insert(localization, at: 0)

  }
  
  mutating func remove(_ localization: T) {
    set.remove(localization)
    array.remove(at: 0)
  }
}
