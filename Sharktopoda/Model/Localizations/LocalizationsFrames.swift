//
//  LocalizationsFrames.swift
//  Created for Sharktopoda on 11/11/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

// MARK: Frame number
extension LocalizationData {
  func frameNumber(for localization: Localization) -> Int {
    frameNumber(of: localization.time)
  }
  
  func frameNumber(of time: CMTime) -> Int {
    guard .zero < time else { return 0 }

    return Int(time.seconds / videoAsset.frameDuration.seconds)
  }

  // CxTBD Add listener to only change this when UserDefaults value changes
  var halfTimeWindow: CMTime {
    let millis = UserDefaults.standard.integer(forKey: PrefKeys.displayTimeWindow)
    let timeWindow = CMTime.from(millis: millis, timescale: videoAsset.timescale)
    return CMTimeMultiplyByFloat64(timeWindow, multiplier: 0.5)
  }
  
  var useDuration: Bool {
    UserDefaults.standard.bool(forKey: PrefKeys.displayUseDuration)
  }
  
}

// MARK: Pause frames
extension LocalizationData {
  func pauseFrameInsert(_ localization: Localization) {
    let (frame, action, index) = frame(for: localization,
                                       into: pauseFrames,
                                       at: localization.time)
    switch action {
      case .add:
        pauseFrames[index] = frame
      case .insert:
        pauseFrames.insert(frame, at: index)
    }
  }
  
  func pauseFrameRemove(_ localization: Localization) {
    let index = insertionIndex(for: pauseFrames, at: localization.time)
    var frame = pauseFrames[index]
    
    guard frame.number == frameNumber(for: localization) else { return }
    
    frame.remove(localization)
    
    if frame.ids.isEmpty {
      pauseFrames.remove(at: index)
    } else {
      pauseFrames[index] = frame
    }
  }
}

// MARK: Forward frames
extension LocalizationData {
  func forwardFrameInsert(_ localization: Localization) {
    let frameTime = forwardFrameTime(localization)
    
    let (frame, action, index) = frame(for: localization, into: forwardFrames, at: frameTime)
    
    switch action {
      case .add:
        forwardFrames[index] = frame
      case .insert:
        forwardFrames.insert(frame, at: index)
    }
  }
  
  func forwardFrameRemove(_ localization: Localization) {
    let frameTime = forwardFrameTime(localization)
    
    let index = insertionIndex(for: forwardFrames, at: frameTime)
    guard index != forwardFrames.count else { return }
    
    var frame = forwardFrames[index]
    guard frame.number == frameNumber(for: localization) else { return }
    
    frame.remove(localization)
    
    if frame.ids.isEmpty {
      forwardFrames.remove(at: index)
    } else {
      forwardFrames[index] = frame
    }
  }
  
  private func forwardFrameTime(_ localization: Localization) -> CMTime {
    return useDuration ? localization.time : localization.time - halfTimeWindow
  }
}

// MARK: Reverse frames
extension LocalizationData {
  func reverseFrameInsert(_ localization: Localization) {
    let insertTime = reverseFrameTime(localization)
    
    let (frame, action, index) = frame(for: localization, into: reverseFrames, at: insertTime)
    switch action {
      case .add:
        reverseFrames[index] = frame
      case .insert:
        reverseFrames.insert(frame, at: index)
    }
  }
  
  func reverseFrameRemove(_ localization: Localization) {
    let frameTime = reverseFrameTime(localization)
    
    let index = insertionIndex(for: reverseFrames, at: frameTime)
    guard index != reverseFrames.count else { return }
    
    var frame = reverseFrames[index]
    guard frame.number == frameNumber(for: localization) else { return }
    
    frame.remove(localization)
    
    if frame.ids.isEmpty {
      reverseFrames.remove(at: index)
    } else {
      reverseFrames[index] = frame
    }
  }
  
  private func reverseFrameTime(_ localization: Localization) -> CMTime {
    let elapsed = localization.time
    let duration = localization.duration
    
    return useDuration ? elapsed + duration : elapsed + halfTimeWindow
  }
}

// MARK: Abstract frame processing
extension LocalizationData {
  /// Binary search for frame insertion index
  func insertionIndex(for frames: [LocalizationFrame], at time: CMTime) -> Int {
    var left = 0
    var right = frames.count - 1
    
    var index = 0
    var found = 0
    
    let frameNumber = frameNumber(of: time)
    
    while left <= right {
      index = (left + right) / 2
      found = frames[index].number
      
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
             at insertTime: CMTime) -> PutInfo {
    
    let frameNumber = frameNumber(of: insertTime)
    let frameTime = CMTimeMultiply(videoAsset.frameDuration, multiplier: CMTimeScale(frameNumber))
    
    var frame: LocalizationFrame
    var action: PutAction
    var index: Int
    
    /// If no frames yet, insert at 0
    if frames.isEmpty {
      frame = LocalizationFrame(number: frameNumber, time: frameTime)
      action = .insert
      index = 0
    } else {
      /// Find insertion index
      index = insertionIndex(for: frames, at: insertTime)
      /// If after end, insert there
      if index == frames.count {
        frame = LocalizationFrame(number: frameNumber, time: frameTime)
        action = .insert
      } else {
        /// Fetch the frame at the insert index
        frame = frames[index]
        /// If frameNumber matches, add
        if frame.number == frameNumber {
          action = .add
        } else {
          /// else insert at index
          frame = LocalizationFrame(number: frameNumber, time: frameTime)
          action = .insert
        }
      }
    }
    frame.add(localization)
    
    return(frame, action, index)
  }
}
