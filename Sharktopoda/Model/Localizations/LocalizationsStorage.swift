//
//  LocalizationsStorage.swift
//  Created for Sharktopoda on 11/11/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

extension LocalizationData {
  func add(_ localization: Localization) {
    guard storage[localization.id] == nil else { return }
    
    storage[localization.id] = localization
    pauseFrameInsert(localization)
    forwardFrameInsert(localization)
    reverseFrameInsert(localization)
  }
  
  func clear() {
    selected.removeAll()
    
    pauseFrames.removeAll()
    forwardFrames.removeAll()
    reverseFrames.removeAll()

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
      forwardFrameRemove(localization)
      reverseFrameRemove(localization)
      selected.remove(id)
      storage[normalizedId] = nil
      
      acc.append(localization)
    }

    removed.forEach {
      $0.layer.removeFromSuperlayer()
      $0.conceptLayer.removeFromSuperlayer()
      $0.unselect()
    }
  }
}
