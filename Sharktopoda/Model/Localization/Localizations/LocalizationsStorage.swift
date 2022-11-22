//
//  LocalizationsStorage.swift
//  Created for Sharktopoda on 11/11/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

extension Localizations {
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
  
  func remove(id: String) -> Localization? {
    guard let localization = storage[id] else { return nil }
    
    pauseFrameRemove(localization)
    forwardFrameRemove(localization)
    reverseFrameRemove(localization)
    selected.remove(id)
    storage[id] = nil
    
    return localization
  }
  
  func update(using control: ControlLocalization) {
    guard let stored = storage[control.uuid] else { return }
    
    if stored.sameTime(as: control) {
      pauseFrameRemove(stored)
      forwardFrameRemove(stored)
      reverseFrameRemove(stored)
      
      stored.update(using: control)
      
      pauseFrameInsert(stored)
      forwardFrameInsert(stored)
      reverseFrameInsert(stored)
    } else {
      stored.update(using: control)
    }
  }
}

