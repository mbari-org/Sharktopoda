//
//  LocalizationsRetrieve.swift
//  Created for Sharktopoda on 11/11/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

// Retrieve Localizations for some time value
extension Localizations {
  func frames(for direction: NSPlayerView.PlayDirection) -> [LocalizationFrame]? {
    switch direction {
      case .forward:
        return forwardFrames
      case .paused:
        return pauseFrames
      case .reverse:
        return reverseFrames
    }
  }
  
  func ids(for direction: NSPlayerView.PlayDirection, at elapsedTime: Int) -> [String]? {
    guard let frames = frames(for: direction),
          !frames.isEmpty else { return nil }
    
    let index = frameIndex(for: frames, at: elapsedTime)
    guard index != frames.count else { return nil }
    
    let frame = frames[index]
    guard frame.frameNumber == frameNumber(elapsedTime: elapsedTime) else { return nil }
    
    return frame.ids
    
  }
  
  func fetch(_ direction: NSPlayerView.PlayDirection, at elapsedTime: Int) -> [Localization]? {
    guard let ids = ids(for: direction, at: elapsedTime) else { return nil }
    
    return ids.map { storage[$0]! }
  }
}
