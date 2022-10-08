//
//  LocalizationSet.swift
//  Created for Sharktopoda on 10/6/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct Localizations {
  private var exist = [String : Localization]()
  private var order = [Localization]()
  
  init() {}
  
  func exists(_ localization: Localization) -> Bool {
    exist[localization.id] != nil
  }

  mutating func add(_ localization: Localization) -> Bool {
    guard !exists(localization) else { return false }

    exist[localization.id] = localization
    addToOrder(localization)

    return true
  }
  
  mutating func clear() {
    exist.removeAll()
    order.removeAll()
  }
  
  mutating func remove(id: String) -> Bool {
    guard let localization = exist[id] else { return false }

    exist[id] = nil
    removeFromOrder(localization)
    return true
  }
  
  mutating func select(id: String) -> Bool {
    guard let localization = exist[id] else { return false }
    
    print("CxInc Localizations.select(\(localization.id))")
    return true
  }

  mutating func update(_ localization: Localization) -> Bool {
    guard exists(localization) else { return false }
    
    exist[localization.id] = localization
    removeFromOrder(localization)
    addToOrder(localization)
    
    return true
  }

  private mutating func addToOrder(_ localization: Localization) {
    // Avoid using binarySearch when clearly not necessary
    if order.isEmpty {
      order.append(localization)
    } else if order.count == 1 {
      if localization < order[0] {
        order.insert(localization, at: 0)
      } else {
        order.append(localization)
      }
    } else if order.last! < localization {
      // Since localizations will often be added at the end, this optimization seems sensible
      order.append(localization)
    } else {
      let index = order.binarySearch(for: localization) ?? order.count
      order.insert(localization, at: index)
    }
  }
  
  private mutating func removeFromOrder(_ localization: Localization) {
    guard !order.isEmpty else { return }
    if order.count == 1 {
      guard localization == order[0] else { return }
      order.remove(at: 0)
    } else {
      if let index = order.binarySearch(for: localization) {
        order.remove(at: index)
      } else {
        return
      }
    }
  }
}
