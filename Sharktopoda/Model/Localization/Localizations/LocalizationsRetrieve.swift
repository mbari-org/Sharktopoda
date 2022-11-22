//
//  LocalizationsRetrieve.swift
//  Created for Sharktopoda on 11/11/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

// Retrieve Localizations for some time value
extension Localizations {
  func frames(for direction: PlayerControl.PlayDirection) -> [LocalizationFrame]? {
    switch direction {
      case .forward:
        return forwardFrames
      case .paused:
        return pauseFrames
      case .reverse:
        return reverseFrames
    }
  }
  
  func ids(for direction: PlayerControl.PlayDirection, at elapsedTime: Int) -> [String] {
    guard let frames = frames(for: direction),
          !frames.isEmpty else { return [] }
    
    let index = frameIndex(for: frames, at: elapsedTime)
    guard index != frames.count else { return [] }
    
    let frame = frames[index]
    guard frame.frameNumber == frameNumber(elapsedTime: elapsedTime) else { return [] }
    
    return frame.ids
  }
  
  func fetch(_ direction: PlayerControl.PlayDirection, at elapsedTime: Int) -> [Localization] {
    let ids = ids(for: direction, at: elapsedTime)
    
    return ids.reduce(into: [Localization]()) { acc, id in
      if let localization = storage[id] {
        acc.append(localization)
      }
    }
  }
}
