//
//  LocalizationSet.swift
//  Created for Sharktopoda on 10/6/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct LocalizationSet {
  private var storage = [String : Localization]()
  private var ordered = [OrderedLocalization]()
  private var selected = Set<String>()

  init() {}
  
  enum Step: Int {
    case left = -1
    case right =  1
    
    func opposite() -> Step {
      self == .left ? .right : .left
    }
  }
}

// Retrieval
extension LocalizationSet {
  func localizations(at elapsedTime: Int,
                     for duration: Int,
                     stepping direction: Step) -> [Localization] {
    let clusterIndex = insertionIndex(for: elapsedTime)
    let startIndex = slide(clusterIndex, direction)
    let endIndex = slide(clusterIndex, direction.opposite(), until: elapsedTime + duration)
    
    let range = startIndex < endIndex ? startIndex..<endIndex : endIndex..<startIndex
    let localizations = localizations(in: range)
    
    return startIndex < endIndex ? localizations : localizations.reversed()
  }
}

/// Storage
extension LocalizationSet {
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
extension LocalizationSet {
  // CxNote Avoid using binarySearch when clearly not necessary
  
  private mutating func addOrdered(_ localization: Localization) {
    let orderedLocalization = OrderedLocalization(for: localization)
    
    if ordered.isEmpty {
      ordered.append(orderedLocalization)
    } else if ordered.count == 1 {
      if orderedLocalization < ordered[0] {
        ordered.insert(orderedLocalization, at: 0)
      } else {
        ordered.append(orderedLocalization)
      }
    } else if ordered.last! < orderedLocalization {
      // Since localizations will often be added at the end, this optimization seems sensible
      ordered.append(orderedLocalization)
    } else {
      let index = insertionIndex(for: orderedLocalization)
      ordered.insert(orderedLocalization, at: index)
    }
  }
  
  private mutating func removeOrdered(_ localization: Localization) {
    guard !ordered.isEmpty else { return }

    let orderedLocalization = OrderedLocalization(for: localization)
    
    if ordered.count == 1 {
      guard orderedLocalization == ordered[0] else { return }
      ordered.remove(at: 0)
    } else {
      let index = insertionIndex(for: orderedLocalization)
      // Since there can be multiple Localizations at a specified time and the insertion index
      // any one of the OrderedLocalizations at that time, we need to find the specfic
      // OrderedLocalization we really want.
      if let localizationIndex = findIndex(matching: orderedLocalization, clusteredAt: index) {
        ordered.remove(at: localizationIndex)
      } else {
        return
      }
    }
  }
}

/// Selected
extension LocalizationSet {
  func allSelected() -> [Localization] {
    selected.map { id in
      storage[id]!
    }
  }

  mutating func clearSelected() {
    selected.removeAll()
  }
  
  mutating func select(_ id: String) -> Bool {
    guard storage[id] != nil else { return false }
    
    selected.insert(id)
    
    return true
  }
}

/// Convenience
extension LocalizationSet {
  func exists(_ localization: Localization) -> Bool {
    storage[localization.id] != nil
  }
  
  private func localizations(in range: Range<Int>) -> [Localization] {
    ordered[range]
      .map { $0.id }
      .map { storage[$0]! }
  }
}

/// Localization index processing
extension LocalizationSet {
  
  private func findIndex(matching localization: OrderedLocalization, clusteredAt index: Int) -> Int? {
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
  
  private func findIndex(matching localization: OrderedLocalization,
                         startingAt index: Int,
                         direction: Step) -> Int? {
    var foundLocalization = ordered[index]
    
    var foundIndex = index
    while foundLocalization.elapsedTime == localization.elapsedTime {
      if foundLocalization.id == localization.id {
        return foundIndex
      }
      foundIndex += direction.rawValue
      foundLocalization = ordered[foundIndex]
    }
    return nil
  }
  
  private func insertionIndex(for localization: OrderedLocalization) -> Int {
    insertionIndex(for: localization.elapsedTime)
  }
  
  private func insertionIndex(for elapsedTime: Int) -> Int {
    var left = 0
    var right = ordered.count - 1

    var index = 0
    var value: Int = .min
    
    while left < right {
      index = (left + right) / 2
      value = ordered[index].elapsedTime
      
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
  
  private func slide(_ index: Int, _ direction: Step, until time: Int? = nil) -> Int {
    let elapsedTime = time ?? ordered[index].elapsedTime
    
    var slideIndex = index
    while ordered[slideIndex + direction.rawValue].elapsedTime == elapsedTime {
      slideIndex += direction.rawValue
    }
    return slideIndex
  }
}
