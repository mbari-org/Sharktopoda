//
//  LocalizationSet.swift
//  Created for Sharktopoda on 10/6/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import SwiftUI

class Localizations {
  private(set) var localizationLayer = [String: LocalizationLayer]()
  
  private var pauseFrames = [LocalizationFrame]()
  private var forwardFrames = [LocalizationFrame]()
  private var reverseFrames = [LocalizationFrame]()
  
  private var selected = Set<String>()
  
  let playerItem: AVPlayerItem
  let frameDuration: Int
  
  init(playerItem: AVPlayerItem, frameDuration: Int) {
    self.playerItem = playerItem
    self.frameDuration = frameDuration
  }
}

/// Enums
extension Localizations {
  private enum PutAction {
    case add
    case insert
  }
  
  private typealias PutInfo = (frame: LocalizationFrame,
                               action: PutAction,
                               index: Int)
}

/// Storage
extension Localizations {
  func add(_ layer: LocalizationLayer) -> Bool {
    guard let localization = layer.localization else { return false }
    
    guard localizationLayer[localization.id] == nil else { return false }
    
    localizationLayer[localization.id] = layer
    
    pauseFrameInsert(localization)
    forwardFrameInsert(localization)
    reverseFrameInsert(localization)
    
    return true
  }
  
  func clear() {
    localizationLayer.removeAll()
    
    pauseFrames.removeAll()
    forwardFrames.removeAll()
    reverseFrames.removeAll()
    
    selected.removeAll()
  }
  
  func remove(id: String) -> Bool {
    guard let layer = localizationLayer[id],
          let localization = layer.localization else { return false }
    
    localizationLayer[id] = nil
    
    pauseFrameRemove(localization)
    forwardFrameRemove(localization)
    reverseFrameRemove(localization)
    
    selected.remove(id)
    
    return true
  }
  
  func update(_ layer: LocalizationLayer) -> Bool {
    guard let localization = layer.localization else { return false }
    
    if let existingStaticLayer = localizationLayer[localization.id],
       let existingLocalization = existingStaticLayer.localization,
       localization.elapsedTime != existingLocalization.elapsedTime {
      
      pauseFrameRemove(existingLocalization)
      pauseFrameInsert(localization)
      
      forwardFrameRemove(existingLocalization)
      forwardFrameInsert(localization)
      
      reverseFrameRemove(existingLocalization)
      reverseFrameInsert(localization)
    }
    localizationLayer[localization.id] = layer
    
    return true
  }
}

// Retrieve Layers
extension Localizations {
  private func frames(_ playDirection: NSPlayerView.PlayDirection) -> [LocalizationFrame]? {
    switch playDirection {
      case .forward:
        return forwardFrames
      case .paused:
        return pauseFrames
      case .reverse:
        return reverseFrames
    }
  }
  
  func layerIds(_ playDirection: NSPlayerView.PlayDirection, at elapsedTime: Int) -> [String]? {
    guard let frames = frames(playDirection) else { return nil }
    
    guard !frames.isEmpty else { return nil }
    
    let index = frameIndex(for: frames, at: elapsedTime)
    guard index != frames.count else { return nil }
    
    let frame = frames[index]
    guard frame.frameNumber == frameNumber(elapsedTime: elapsedTime) else { return nil }
    
    return frame.ids
  }
  
  func layers(_ playDirection: NSPlayerView.PlayDirection, at elapsedTime: Int) -> [LocalizationLayer]? {
    guard let ids = layerIds(playDirection, at: elapsedTime) else { return nil }
    
    return ids.map { localizationLayer[$0]! }
  }
}

/// Frame number
extension Localizations {
  func frameNumber(for localization: Localization) -> Int {
    frameNumber(elapsedTime: localization.elapsedTime)
  }
  
  func frameNumber(elapsedTime: Int) -> Int {
    guard 0 < elapsedTime else { return 0 }
    
    return (elapsedTime + frameDuration / 2) / frameDuration
  }
}

/// Pause frames
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
    var localizationFrame = pauseFrames[index]
    
    if localizationFrame.frameNumber == frameNumber(for: localization) {
      localizationFrame.remove(localization)
    }
  }
}

/// Forward frames
extension Localizations {
  private func forwardFrameInsert(_ localization: Localization) {
    let useDuration = UserDefaults.standard.bool(forKey: PrefKeys.displayUseDuration)
    let timeWindow = UserDefaults.standard.integer(forKey: PrefKeys.displayTimeWindow)
    
    let elapsed = localization.elapsedTime
    let insertTime = useDuration ? elapsed : elapsed - (timeWindow / 2)
    
    let (frame, action, index) = frame(for: localization, into: forwardFrames, at: insertTime)
                                      
    switch action {
      case .add:
        forwardFrames[index] = frame
      case .insert:
        forwardFrames.insert(frame, at: index)
    }
  }
  
  private func forwardFrameRemove(_ localization: Localization) {
    fatalError("CxInc: LocalizationSet.forwardFrameRemove")
  }
}

/// Reverse frames
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
    fatalError("CxInc: LocalizationSet.reverseFrameRemove")
  }
}

/// Abstract frame processing
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

/// Selected
extension Localizations {
  func allSelected() -> [LocalizationLayer] {
    selected.map { id in
      localizationLayer[id]!
    }
  }
  
  func clearSelected() {
    selected.forEach { id in
      localizationLayer[id]!.select(false)
    }
    selected.removeAll()
  }
  
  func select(id: String) -> Bool {
    guard let layer = localizationLayer[id] else { return false }

    clearSelected()

    selected.insert(id)
    layer.select(true)
    
    return true
  }
  
  func select(ids: [String]) -> [Bool] {
    clearSelected()

    return ids.map { id in
      guard localizationLayer[id] != nil else { return false }
      selected.insert(id)
      return true
    }
  }
}
