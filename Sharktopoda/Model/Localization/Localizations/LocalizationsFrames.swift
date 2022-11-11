//
//  LocalizationsFrames.swift
//  Created for Sharktopoda on 11/11/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

// MARK: Frame number
extension Localizations {
  func frameNumber(for localization: Localization) -> Int {
    frameNumber(elapsedTime: localization.elapsedTime)
  }
  
  func frameNumber(elapsedTime: Int) -> Int {
    guard 0 < elapsedTime else { return 0 }
    
    return (elapsedTime + frameDuration / 2) / frameDuration
  }
}

// MARK: Pause frames
extension Localizations {
  func pauseFrameInsert(_ localization: Localization) {
    let insertTime = localization.elapsedTime
    let (frame, action, index) = frame(for: localization,
                                       into: pauseFrames,
                                       at: insertTime)
    switch action {
      case .add:
        pauseFrames[index] = frame
      case .insert:
        pauseFrames.insert(frame, at: index)
    }
  }
  
  func pauseFrameRemove(_ localization: Localization) {
    let index = frameIndex(for: pauseFrames, at: localization.elapsedTime)
    var frame = pauseFrames[index]
    
    guard frame.frameNumber == frameNumber(for: localization) else { return }
    
    frame.remove(localization)
    
    if frame.ids.isEmpty {
      pauseFrames.remove(at: index)
    } else {
      pauseFrames[index] = frame
    }
  }
}

// MARK: Forward frames
extension Localizations {
  func forwardFrameInsert(_ localization: Localization) {
    let useDuration = UserDefaults.standard.bool(forKey: PrefKeys.displayUseDuration)
    let timeWindow = UserDefaults.standard.integer(forKey: PrefKeys.displayTimeWindow)
    
    let elapsed = localization.elapsedTime
    let frameTime = useDuration ? elapsed : elapsed - (timeWindow / 2)
    
    let (frame, action, index) = frame(for: localization, into: forwardFrames, at: frameTime)
    
    switch action {
      case .add:
        forwardFrames[index] = frame
      case .insert:
        forwardFrames.insert(frame, at: index)
    }
  }
  
  func forwardFrameRemove(_ localization: Localization) {
    let useDuration = UserDefaults.standard.bool(forKey: PrefKeys.displayUseDuration)
    let timeWindow = UserDefaults.standard.integer(forKey: PrefKeys.displayTimeWindow)
    
    let elapsed = localization.elapsedTime
    let frameTime = useDuration ? elapsed : elapsed - (timeWindow / 2)
    let index = frameIndex(for: forwardFrames, at: frameTime)
    guard index != forwardFrames.count else { return }
    
    var frame = forwardFrames[index]
    guard frame.frameNumber == frameNumber(for: localization) else { return }
    
    frame.remove(localization)
    
    if frame.ids.isEmpty {
      forwardFrames.remove(at: index)
    } else {
      forwardFrames[index] = frame
    }
  }
}

// MARK: Reverse frames
extension Localizations {
  func reverseFrameInsert(_ localization: Localization) {
    let useDuration = UserDefaults.standard.bool(forKey: PrefKeys.displayUseDuration)
    let timeWindow = UserDefaults.standard.integer(forKey: PrefKeys.displayTimeWindow)
    
    let elapsed = localization.elapsedTime
    let duration = localization.duration
    
    let insertTime = useDuration ? elapsed + duration : elapsed + (timeWindow / 2)
    let (frame, action, index) = frame(for: localization, into: reverseFrames, at: insertTime)
    switch action {
      case .add:
        reverseFrames[index] = frame
      case .insert:
        reverseFrames.insert(frame, at: index)
    }
  }
  
  func reverseFrameRemove(_ localization: Localization) {
    let useDuration = UserDefaults.standard.bool(forKey: PrefKeys.displayUseDuration)
    let timeWindow = UserDefaults.standard.integer(forKey: PrefKeys.displayTimeWindow)
    
    let elapsed = localization.elapsedTime
    let duration = localization.duration
    
    let frameTime = useDuration ? elapsed + duration : elapsed + (timeWindow / 2)
    let index = frameIndex(for: reverseFrames, at: frameTime)
    guard index != reverseFrames.count else { return }
    
    var frame = reverseFrames[index]
    guard frame.frameNumber == frameNumber(for: localization) else { return }
    
    frame.remove(localization)
    
    if frame.ids.isEmpty {
      reverseFrames.remove(at: index)
    } else {
      reverseFrames[index] = frame
    }
  }
}

// MARK: Abstract frame processing
extension Localizations {
  func frameIndex(for frames: [LocalizationFrame], at elapsedTime: Int) -> Int {
    var left = 0
    var right = frames.count - 1
    
    var index = 0
    var found = 0
    
    let frameNumber = frameNumber(elapsedTime: elapsedTime)
    
    while left <= right {
      index = (left + right) / 2
      found = frames[index].frameNumber
      
      if found == frameNumber {
        return index
      } else if found < frameNumber {
        left = index + 1
      } else {
        right = index - 1
      }
    }
    
    return found < frameNumber ? left : right + 1
  }
  
  func frame(for localization: Localization,
             into frames: [LocalizationFrame],
             at insertTime: Int) -> PutInfo {
    
    let frameNumber = frameNumber(elapsedTime: insertTime)
    
    var frame: LocalizationFrame
    var action: PutAction
    var index: Int
    
    /// If no frames yet, insert at 0
    if frames.isEmpty {
      frame = LocalizationFrame(localization, frameNumber: frameNumber)
      action = .insert
      index = 0
    } else {
      /// Find insertion index
      index = frameIndex(for: frames, at: insertTime)
      /// If after end, insert there
      if index == frames.count {
        frame = LocalizationFrame(localization, frameNumber: frameNumber)
        action = .insert
      } else {
        /// Fetch the frame at the insert index
        frame = frames[index]
        /// If frameNumber matches, add
        if frame.frameNumber == frameNumber {
          action = .add
        } else {
          /// else insert at index
          frame = LocalizationFrame(localization, frameNumber: frameNumber)
          action = .insert
        }
      }
    }
    frame.add(localization)
    
    return(frame, action, index)
  }
}
