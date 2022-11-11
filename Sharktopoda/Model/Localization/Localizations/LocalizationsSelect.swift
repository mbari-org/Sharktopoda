//
//  LocalizationsSelect.swift
//  Created for Sharktopoda on 11/11/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

extension Localizations {
  func clearSelected() {
    guard !selected.isEmpty else { return }
    
    selected.forEach { storage[$0]?.select(false) }
    selected.removeAll()
    sendIdsMessage(.selectLocalizations, ids: [])
  }
  
  func deleteSelected() -> Bool {
    guard !selected.isEmpty else { return false }
    
    sendIdsMessage(.removeLocalizations, ids: selectedIds())
    
    selected.forEach { let _ = remove(id: $0) }

//    sendIdsMessage(.selectLocalizations, ids: [])
    
    return true
  }
  
  func select(id: String, clear: Bool = true) -> Bool {
    guard let localization = storage[id] else { return false }
    
    if clear {
      clearSelected()
    }
    
    selected.insert(id)
    localization.select(true)
    
    sendIdsMessage(.selectLocalizations, ids: selectedIds())
    
    return true
  }
  
  func select(ids: [String]) -> [Bool] {
    clearSelected()
    
    let results = ids.map { id in
      guard let localization = storage[id] else { return false }
      selected.insert(id)
      localization.select(true)
      return true
    }
    
    sendIdsMessage(.selectLocalizations, ids: ids)
    
    return results
  }
  
  func select(using rect: CGRect, at elapsedTime: Int) {
    guard let pausedLocalizations = fetch(.paused, at: elapsedTime) else { return }
    
    let ids = pausedLocalizations
      .filter { rect.intersects($0.layer.frame) }
      .map { $0.id }
    
    let _ = select(ids: ids)
  }
  
  func selectedIds() -> [String] {
    selected.map { $0 }
  }
  
  func unselect(id: String) {
    guard let localization = storage[id] else { return }
    
    selected.remove(localization.id)
    localization.select(false)
    
    sendIdsMessage(.selectLocalizations, ids: selectedIds())
  }
}
