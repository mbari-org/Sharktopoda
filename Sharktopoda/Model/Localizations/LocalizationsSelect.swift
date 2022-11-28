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
  
  func deleteSelected() {
    guard !selected.isEmpty else { return }
    
    let ids = selectedIds()

    sendIdsMessage(.removeLocalizations, ids: ids)
    remove(ids: ids)
    
    // CxTBD Is an updated selected message necessary?
    sendIdsMessage(.selectLocalizations, ids: selectedIds())
  }
  
  func select(id: String, clear: Bool = true) {
    guard let localization = storage[id] else { return }
    
    if clear {
      clearSelected()
    }
    
    selected.insert(id)
    localization.select(true)
    
    sendIdsMessage(.selectLocalizations, ids: selectedIds())
  }
  
  func select(ids: [String], notifyClient: Bool = true) {
    clearSelected()
    
    ids.forEach { id in
      guard let localization = storage[id] else { return }
      selected.insert(id)
      localization.select(true)
    }
    if notifyClient {
      sendIdsMessage(.selectLocalizations, ids: selectedIds())
    }
  }
  
  func select(using rect: CGRect, at elapsedTime: Int) {
    let pausedLocalizations = fetch(.paused, at: elapsedTime)
    
    let ids = pausedLocalizations
      .filter { rect.intersects($0.layer.frame) }
      .map(\.id)
    
    select(ids: ids)
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
