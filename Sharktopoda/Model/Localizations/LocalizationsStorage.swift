//
//  LocalizationsStorage.swift
//  Created for Sharktopoda on 11/11/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

extension LocalizationData {
  /// Returns false, and does not store the localization, if one with the same id already exists
  @discardableResult
  func add(_ localization: Localization) -> Bool {
    guard storage[localization.id] == nil else { return false }
    
    storage[localization.id] = localization
    pauseFrameInsert(localization)
    return true
  }

  func clear() {
    selected.removeAll()

    pauseFrames.removeAll()

    storage.removeAll()
  }
  
  func exists(id: String) -> Bool {
    let normalizedId = SharktopodaData.normalizedId(id)
    return storage[normalizedId] != nil
  }
  
  func remove(ids: [String]) {
    let removed = ids.reduce(into: [Localization]()) { acc, id in
      let normalizedId = SharktopodaData.normalizedId(id)
      guard let localization = storage[normalizedId] else { return }

      pauseFrameRemove(localization)
      selected.remove(normalizedId)
      storage[normalizedId] = nil
      
      acc.append(localization)
    }

    removed.forEach {
      $0.layer.removeFromSuperlayer()
      $0.conceptLayer.removeFromSuperlayer()
      $0.unselect()
    }

    if let current = windowData?.playerView.nsPlayerView.currentLocalization,
       removed.contains(where: { $0 === current }) {
      windowData?.playerView.nsPlayerView.removeCurrentLocalization()
    }
  }
}
