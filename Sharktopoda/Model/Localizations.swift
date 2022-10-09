//
//  LocalizationSet.swift
//  Created for Sharktopoda on 10/6/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct Localizations {
  private var _storage = [String : Localization]()
  private var _order = [Localization]()
  private var _selected = Set<String>()

  init() {}
}

/// Storage
extension Localizations {
  mutating func add(_ localization: Localization) -> Bool {
    guard !exists(localization) else { return false }
    
    _storage[localization.id] = localization
    addOrdered(localization)
    
    return true
  }
  
  mutating func clear() {
    _storage.removeAll()
    _order.removeAll()
    _selected.removeAll()
  }
  
  mutating func remove(id: String) -> Bool {
    guard let localization = _storage[id] else { return false }
    
    _storage[id] = nil
    removeOrdered(localization)
    _selected.remove(localization.id)

    return true
  }
    
  mutating func update(_ localization: Localization) -> Bool {
    guard exists(localization) else { return false }
    
    _storage[localization.id] = localization
    removeOrdered(localization)
    addOrdered(localization)
    
    return true
  }
}

/// Order
extension Localizations {
  private mutating func addOrdered(_ localization: Localization) {
    // Avoid using binarySearch when clearly not necessary
    if _order.isEmpty {
      _order.append(localization)
    } else if _order.count == 1 {
      if localization < _order[0] {
        _order.insert(localization, at: 0)
      } else {
        _order.append(localization)
      }
    } else if _order.last! < localization {
      // Since localizations will often be added at the end, this optimization seems sensible
      _order.append(localization)
    } else {
      let index = _order.binarySearch(for: localization) ?? _order.count
      _order.insert(localization, at: index)
    }
  }
  
  private mutating func removeOrdered(_ localization: Localization) {
    guard !_order.isEmpty else { return }
    if _order.count == 1 {
      guard localization == _order[0] else { return }
      _order.remove(at: 0)
    } else {
      if let index = _order.binarySearch(for: localization) {
        _order.remove(at: index)
      } else {
        return
      }
    }
  }
}

/// Selected
extension Localizations {
  mutating func select(_ id: String) -> Bool {
    guard _storage[id] != nil else { return false }
    
    _selected.insert(id)
    
    return true
  }
  
  mutating func clearSelected() {
    _selected.removeAll()
  }
  
  func selected() -> [Localization] {
    _selected.map { id in
      _storage[id]!
    }
  }
}

/// Convenience
extension Localizations {
  func exists(_ localization: Localization) -> Bool {
    _storage[localization.id] != nil
  }
}
