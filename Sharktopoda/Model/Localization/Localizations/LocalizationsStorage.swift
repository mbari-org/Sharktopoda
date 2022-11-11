//
//  LocalizationsStorage.swift
//  Created for Sharktopoda on 11/11/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

extension Localizations {
  func add(_ localization: Localization) -> Bool {
    guard storage[localization.id] == nil else { return false }
    
    storage[localization.id] = localization
    pauseFrameInsert(localization)
    forwardFrameInsert(localization)
    reverseFrameInsert(localization)
    
    return true
  }
  
  func clear() {
    selected.removeAll()
    
    pauseFrames.removeAll()
    forwardFrames.removeAll()
    reverseFrames.removeAll()

    storage.removeAll()
  }
  
  func remove(id: String) -> Bool {
    guard let localization = storage[id] else { return false }
    
    pauseFrameRemove(localization)
    forwardFrameRemove(localization)
    reverseFrameRemove(localization)
    
    selected.remove(id)
    
    localization.layer.removeFromSuperlayer()
    storage[id] = nil
    
    return true
  }
  
  func update(using control: ControlLocalization) -> Bool {
    guard let stored = storage[control.uuid] else { return false }
    
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
    
    return true
  }
}

