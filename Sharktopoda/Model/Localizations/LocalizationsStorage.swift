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
  
  func remove(ids: [String]) {
    let removed = ids.reduce(into: [Localization]()) { acc, id in
      guard let localization = storage[id] else { return }

      pauseFrameRemove(localization)
      forwardFrameRemove(localization)
      reverseFrameRemove(localization)
      selected.remove(id)
      storage[id] = nil
      
      acc.append(localization)
    }

    DispatchQueue.main.async {
      removed.forEach {
        $0.layer.removeFromSuperlayer()
        $0.unselect()
      }
    }
  }
  
  func update(using control: ControlLocalization) {
    guard let localization = storage[control.uuid] else { return }
    
    if localization.sameTime(as: control) {
      pauseFrameRemove(localization)
      forwardFrameRemove(localization)
      reverseFrameRemove(localization)
      
      localization.update(using: control)
      
      pauseFrameInsert(localization)
      forwardFrameInsert(localization)
      reverseFrameInsert(localization)
    } else {
      localization.update(using: control)
    }
  }
}

