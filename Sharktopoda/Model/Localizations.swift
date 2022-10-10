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
  
  enum Slide: Int {
    case left = -1
    case right =  1
  }
}

extension Localizations {
  func allLocalizations(at elapsedTimeMillis: Int,
                        for duration: Int,
                        inDirection direction: Slide) {
    
  }
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
  // CxNote Avoid using binarySearch when clearly not necessary
  
  private mutating func addOrdered(_ localization: Localization) {
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
      let index = insertionIndex(for: localization)
      _order.insert(localization, at: index)
    }
  }
  
  private mutating func removeOrdered(_ localization: Localization) {
    guard !_order.isEmpty else { return }
    
    if _order.count == 1 {
      guard localization == _order[0] else { return }
      _order.remove(at: 0)
    } else {
      let index = insertionIndex(for: localization)
      // Since there can be multiple Localizations at a specified time and the insertion index
      // any one of the Localizations at that time, we need to find the specfic Localization
      // we really want.
      if let localizationIndex = findIndex(matching: localization, clusteredAt: index) {
        _order.remove(at: localizationIndex)
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
  
  
  private func allLocalizations(atIndex index: Int, matching elapsedTime: Int) -> [Localization] {
    var localizations = [Localization]()
    localizations.append(_order[index])

    return localizations
  }
}

/// Localization index processing
extension Localizations {
  
  private func findIndex(matching localization: Localization, clusteredAt index: Int) -> Int? {
    if let localizationIndex = findIndex(matching: localization,
                                         startingAt: index,
                                         direction: .right) {
      return localizationIndex
    } else
    if let localizationIndex = findIndex(matching: localization,
                                         startingAt: index - 1,
                                         direction: .left) {
      return localizationIndex
    }
    return nil
  }
  
  private func findIndex(matching localization: Localization,
                         startingAt index: Int,
                         direction: Slide) -> Int? {
    var foundLocalization = _order[index]
    
    var foundIndex = index
    while foundLocalization.elapsedTimeMillis == localization.elapsedTimeMillis {
      if foundLocalization.id == localization.id {
        return foundIndex
      }
      foundIndex += direction.rawValue
      foundLocalization = _order[foundIndex]
    }
    return nil
  }
  
  private func insertionIndex(for localization: Localization) -> Int {
    insertionIndex(for: localization.elapsedTimeMillis)
  }
  
  private func insertionIndex(for elapsedTime: Int) -> Int {
    var left = 0
    var right = _order.count - 1

    var index = 0
    var value: Int = .min
    
    while left < right {
      index = (left + right) / 2
      value = _order[index].elapsedTimeMillis
      
      if value == elapsedTime {
        return index
      } else
      if value < elapsedTime {
        left = slide(index, .right) + 1
      } else {
        right = slide(index, .left) - 1
      }
    }
    
    return value < left ? left : right + 1
  }
  
  private func slide(_ index: Int, _ direction: Slide) -> Int {
    let elapsedTime = _order[index].elapsedTimeMillis
    
    var slideIndex = index
    while _order[slideIndex + direction.rawValue].elapsedTimeMillis == elapsedTime {
      slideIndex += direction.rawValue
    }
    return slideIndex
  }
}
