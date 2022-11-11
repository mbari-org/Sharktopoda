//
//  LocalizationSet.swift
//  Created for Sharktopoda on 10/6/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import SwiftUI

class Localizations {
  private(set) var storage = [String: Localization]()
  
  private var pauseFrames = [LocalizationFrame]()
  private var forwardFrames = [LocalizationFrame]()
  private var reverseFrames = [LocalizationFrame]()
  
  private var selected = Set<String>()
  
  let videoAsset: VideoAsset
  let frameDuration: Int
  
  init(videoAsset: VideoAsset, frameDuration: Int) {
    self.videoAsset = videoAsset
    self.frameDuration = frameDuration
  }
}

// MARK: Enums
extension Localizations {
  private enum PutAction {
    case add
    case insert
  }
  
  private typealias PutInfo = (frame: LocalizationFrame,
                               action: PutAction,
                               index: Int)
}

// MARK: Storage
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
    storage.removeAll()
    
    pauseFrames.removeAll()
    forwardFrames.removeAll()
    reverseFrames.removeAll()
    
    selected.removeAll()
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

// Retrieve Localizations for some time value
extension Localizations {
  private func frames(for direction: NSPlayerView.PlayDirection) -> [LocalizationFrame]? {
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
  private func pauseFrameInsert(_ localization: Localization) {
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
  
  private func pauseFrameRemove(_ localization: Localization) {
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
  private func forwardFrameInsert(_ localization: Localization) {
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
  
  private func forwardFrameRemove(_ localization: Localization) {
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
  private func reverseFrameInsert(_ localization: Localization) {
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
  
  private func reverseFrameRemove(_ localization: Localization) {
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
  private func frameIndex(for frames: [LocalizationFrame], at elapsedTime: Int) -> Int {
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
  
  private func frame(for localization: Localization,
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

// MARK: Selected
extension Localizations {
  func clearSelected() {
    selected.forEach { storage[$0]?.select(false) }
    selected.removeAll()
    sendSelectedMessage()
  }
  
  func deleteSelected() -> Bool {
    guard !selected.isEmpty else { return false }
    selected.forEach { let _ = remove(id: $0) }
    sendSelectedMessage()
    /// CxInc send delete message
    return true
  }
  
  func select(id: String, clear: Bool = true) -> Bool {
    guard let localization = storage[id] else { return false }

    if clear {
      clearSelected()
    }

    selected.insert(id)
    localization.select(true)

    sendSelectedMessage()
    
    return true
  }
  
  func select(ids: [String]) -> [Bool] {
    clearSelected()

    let results = ids.map { id in
      guard let localization = storage[id] else { return false }
      selected.insert(id)
      localization.select(true)
      return true
    }
    
    sendSelectedMessage()
    
    return results
  }
  
  func select(using rect: CGRect, at elapsedTime: Int) {
    guard let pausedLocalizations = fetch(.paused, at: elapsedTime) else { return }

    let ids = pausedLocalizations
      .filter { rect.intersects($0.layer.frame) }
      .map { $0.id }

    let _ = select(ids: ids)
  }
  
  func selectedIds() -> [String] {
    selected.map { $0 }
  }
  
  func unselect(id: String) {
    guard let localization = storage[id] else { return }
    
    selected.remove(localization.id)
    localization.select(false)
    
    sendSelectedMessage()
  }
}

// MARK: Resize all
extension Localizations {
  func resize(for videoRect: CGRect) {
    for localization in storage.values {
      localization.resize(for: videoRect)
    }
  }
}
// MARK: UDP Messaging
extension Localizations {
  func sendSelectedMessage() {
    if let client = UDP.sharktopodaData.udpClient {
      let message = ClientSelectLocalizations(videoId: videoAsset.id, ids: selectedIds())
      client.process(message)
    }
  }
  
  func sendUpdateMessage(ids: [String]) {
    if let client = UDP.sharktopodaData.udpClient {
      let message = ClientUpdateLocalizations(videoId: videoAsset.id,
                                              localizations: ids.map { storage[$0] })
      client.process(message)
    }
  }

}
