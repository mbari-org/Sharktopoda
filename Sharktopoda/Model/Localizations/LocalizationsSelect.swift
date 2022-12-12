//
//  LocalizationsSelect.swift
//  Created for Sharktopoda on 11/11/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

extension LocalizationData {
  func clearSelected() {
    guard !selected.isEmpty else { return }
  
    selected.forEach { storage[$0]?.unselect() }
    selected.removeAll()
    sendIdsMessage(.selectLocalizations, ids: [])
  }
  
  func deleteSelected() {
    guard !selected.isEmpty else { return }
    
    let ids = selectedIds

    sendIdsMessage(.removeLocalizations, ids: ids)
    remove(ids: ids)
    
    // CxTBD Is an updated selected message necessary?
    sendIdsMessage(.selectLocalizations, ids: ids)
  }
  
  func select(id: String, clear: Bool = true) -> Bool {
    guard !selected.contains(id) else { return false }
    guard let localization = storage[id] else { return false }
    
    if clear {
      clearSelected()
    }
    
    localization.select()
    selected.insert(id)
    
    sendIdsMessage(.selectLocalizations, ids: selectedIds)
    
    return true
  }
  
  func select(ids: [String], notifyClient: Bool = true) {
    clearSelected()
    
    ids.forEach { id in
      guard let localization = storage[id] else { return }
      localization.select()
      selected.insert(id)
    }
    if notifyClient {
      sendIdsMessage(.selectLocalizations, ids: selectedIds)
    }
  }
  
  func select(using rect: CGRect, at elapsedTime: Int) {
    let pausedLocalizations = fetch(.paused, at: elapsedTime)
    
    let ids = pausedLocalizations
      .filter { rect.intersects($0.layer.frame) }
      .map(\.id)
    
    select(ids: ids)
  }
  
  var selectedIds: [String] {
    selected.map { $0 }
  }
  
  var selectedLocalizations: [Localization] {
    selected.map { storage[$0]! }
  }
  
  func unselect(id: String) {
    guard let localization = storage[id] else { return }

    localization.unselect()
    selected.remove(localization.id)
    
    sendIdsMessage(.selectLocalizations, ids: selectedIds)
  }
}
