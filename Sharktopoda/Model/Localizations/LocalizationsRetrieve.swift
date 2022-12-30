//
//  LocalizationsRetrieve.swift
//  Created for Sharktopoda on 11/11/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

// Retrieve Localizations for some time value
extension LocalizationData {
  func fetch(ids: [String]) -> [Localization] {
    ids.reduce(into: [Localization]()) { acc, id in
      if let localization = storage[id] {
        acc.append(localization)
      }
    }
  }
  
  func fetch(_ direction: WindowData.PlayerDirection, at elapsedTime: Int) -> [Localization] {
    fetch(ids: ids(for: direction, at: elapsedTime))
  }

  func frames(for direction: WindowData.PlayerDirection) -> [LocalizationFrame]? {
    switch direction {
      case .forward:
        return forwardFrames
      case .paused:
        return pauseFrames
      case .backward:
        return reverseFrames
    }
  }
  
  func ids(for direction: WindowData.PlayerDirection, at elapsedTime: Int) -> [String] {
    guard let frames = frames(for: direction),
          !frames.isEmpty else { return [] }
    
    let index = insertionIndex(for: frames, at: elapsedTime)
    guard index != frames.count else { return [] }
    
    let frame = frames[index]
    guard frame.number == frameNumber(of: elapsedTime) else { return [] }
    
    return frame.ids
  }
  
  func ids(startTime: Int, endTime: Int) -> [String] {
    guard !forwardFrames.isEmpty else { return [] }
    
    /// CxNote frameIndex returns insertion 
    let startIndex = insertionIndex(for: forwardFrames, at: startTime)
    let endIndex = insertionIndex(for: forwardFrames, at: endTime)

    var indices = [String]()
    for index in startIndex...endIndex {
      let frame = forwardFrames[index]
      indices.append(contentsOf: frame.ids)
    }
    return indices
  }
}
