//
//  LocalizationSet.swift
//  Created for Sharktopoda on 10/6/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct Localizations {
  private var storage = [String : Localization]()
  private var ordered = [Localization]()
  private var selected = Set<String>()

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
    
    storage[localization.id] = localization
    addOrdered(localization)
    
    return true
  }
  
  mutating func clear() {
    storage.removeAll()
    ordered.removeAll()
    selected.removeAll()
  }
  
  mutating func remove(id: String) -> Bool {
    guard let localization = storage[id] else { return false }
    
    storage[id] = nil
    removeOrdered(localization)
    selected.remove(localization.id)

    return true
  }
    
  mutating func update(_ localization: Localization) -> Bool {
    guard exists(localization) else { return false }
    
    storage[localization.id] = localization
    removeOrdered(localization)
    addOrdered(localization)
    
    return true
  }
}

/// Order
extension Localizations {
  // CxNote Avoid using binarySearch when clearly not necessary
  
  private mutating func addOrdered(_ localization: Localization) {
    if ordered.isEmpty {
      ordered.append(localization)
    } else if ordered.count == 1 {
      if localization < ordered[0] {
        ordered.insert(localization, at: 0)
      } else {
        ordered.append(localization)
      }
    } else if ordered.last! < localization {
      // Since localizations will often be added at the end, this optimization seems sensible
      ordered.append(localization)
    } else {
      let index = insertionIndex(for: localization)
      ordered.insert(localization, at: index)
    }
  }
  
  private mutating func removeOrdered(_ localization: Localization) {
    guard !ordered.isEmpty else { return }
    
    if ordered.count == 1 {
      guard localization == ordered[0] else { return }
      ordered.remove(at: 0)
    } else {
      let index = insertionIndex(for: localization)
      // Since there can be multiple Localizations at a specified time and the insertion index
      // any one of the Localizations at that time, we need to find the specfic Localization
      // we really want.
      if let localizationIndex = findIndex(matching: localization, clusteredAt: index) {
        ordered.remove(at: localizationIndex)
      } else {
        return
      }
    }
  }
}

/// Selected
extension Localizations {
  mutating func select(_ id: String) -> Bool {
    guard storage[id] != nil else { return false }
    
    selected.insert(id)
    
    return true
  }
  
  mutating func clearSelected() {
    selected.removeAll()
  }
  
  func selected() -> [Localization] {
    selected.map { id in
      storage[id]!
    }
  }
}

/// Convenience
extension Localizations {
  func exists(_ localization: Localization) -> Bool {
    storage[localization.id] != nil
  }
  
  
  private func allLocalizations(atIndex index: Int, matching elapsedTime: Int) -> [Localization] {
    var localizations = [Localization]()
    localizations.append(ordered[index])

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
    var foundLocalization = ordered[index]
    
    var foundIndex = index
    while foundLocalization.elapsedTimeMillis == localization.elapsedTimeMillis {
      if foundLocalization.id == localization.id {
        return foundIndex
      }
      foundIndex += direction.rawValue
      foundLocalization = ordered[foundIndex]
    }
    return nil
  }
  
  private func insertionIndex(for localization: Localization) -> Int {
    insertionIndex(for: localization.elapsedTimeMillis)
  }
  
  private func insertionIndex(for elapsedTime: Int) -> Int {
    var left = 0
    var right = ordered.count - 1

    var index = 0
    var value: Int = .min
    
    while left < right {
      index = (left + right) / 2
      value = ordered[index].elapsedTimeMillis
      
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
    let elapsedTime = ordered[index].elapsedTimeMillis
    
    var slideIndex = index
    while ordered[slideIndex + direction.rawValue].elapsedTimeMillis == elapsedTime {
      slideIndex += direction.rawValue
    }
    return slideIndex
  }
}
