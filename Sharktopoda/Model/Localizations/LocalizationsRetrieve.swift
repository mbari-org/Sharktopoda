//
//  LocalizationsRetrieve.swift
//  Created for Sharktopoda on 11/11/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

// Retrieve Localizations for some time value
extension LocalizationData {
  func fetch(ids: [String]) -> [Localization] {
    ids.reduce(into: [Localization]()) { acc, id in
      if let localization = storage[id] {
        acc.append(localization)
      }
    }
  }

  func fetch(_ direction: WindowData.PlayerDirection, at time: CMTime) -> [Localization] {
    fetch(ids: ids(for: direction, at: time))
  }

  func fetch(spanning time: CMTime) -> [Localization] {
    guard !pauseFrames.isEmpty else { return [] }
    
    var ids = [String]()
    let spanIndex = min(insertionIndex(for: pauseFrames, at: time), pauseFrames.count - 1)
    
    /// Add localizations at the specified time
    if inTimeWindow(time, pauseFrames[spanIndex].time) {
      ids.append(contentsOf: pauseFrames[spanIndex].ids)
    }
    
    /// Scan left and add
    var index = spanIndex - 1
    while -1 < index,
           inTimeWindow(time, pauseFrames[index].time) {
      ids.append(contentsOf: pauseFrames[index].ids)
      index -= 1
    }
    
    /// Scan right and add
    index = spanIndex + 1
    while index < pauseFrames.count,
          inTimeWindow(time, pauseFrames[index].time) {
      ids.append(contentsOf: pauseFrames[index].ids)
      index += 1
    }
    
    return fetch(ids: ids)
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

  func ids(for direction: WindowData.PlayerDirection, at time: CMTime) -> [String] {
    guard let frames = frames(for: direction),
          !frames.isEmpty else { return [] }
    
    let index = insertionIndex(for: frames, at: time)
    guard index != frames.count else { return [] }
    
    let frame = frames[index]
    guard frame.number == frameNumber(of: time) else { return [] }
    
    return frame.ids
  }

  func inTimeWindow(_ t1: CMTime, _ t2: CMTime) -> Bool {
    if (t1 < t2) {
      return (t2 - t1) <= halfTimeWindow
    } else {
      return (t1 - t2) < halfTimeWindow
    }
  }
}
