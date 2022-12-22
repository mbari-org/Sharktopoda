//
//  LocalizationsSelect.swift
//  Created for Sharktopoda on 11/11/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

extension LocalizationData {
  func clearSelected(notifyClient: Bool = true) {
    guard !selected.isEmpty else { return }

    unselect(ids: selectedIds, notifyClient: notifyClient)
  }
  
  func deleteSelected() {
    guard !selected.isEmpty else { return }
    
    let ids = selectedIds

    remove(ids: ids)

    sendIdsMessage(.removeLocalizations, ids: ids)
  }
  
  func select(ids: [String], notifyClient: Bool = true) {
    ids.forEach { uuid in
      let id = SharktopodaData.normalizedId(uuid)
      guard !selected.contains(id) else { return }
      guard let localization = storage[id] else { return }
      
      selected.insert(id)
      localization.select()
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
    
    select(ids: ids, notifyClient: true)
  }
  
  var selectedIds: [String] {
    selected.map { $0 }
  }
  
  var selectedLocalizations: [Localization] {
    selected.map { storage[$0]! }
  }
  
  func unselect(ids: [String], notifyClient: Bool = true) {
    ids.forEach { id in
      guard let localization = storage[id] else { return }

      localization.unselect()
      selected.remove(id)
    }

    if notifyClient {
      sendIdsMessage(.selectLocalizations, ids: selectedIds)
    }
  }
}
