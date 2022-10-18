//
//  LocalizationSet.swift
//  Created for Sharktopoda on 10/6/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct LocalizationSet {
  private var storage = [String : Localization]()
  private var frames = [LocalizationFrame]()
  private var selected = Set<String>()
  
  let frameDuration: Int
  
  init(frameDuration: Int) {
    self.frameDuration = frameDuration
  }
  
  enum Step: Int {
    case left = -1
    case right =  1
    
    func opposite() -> Step {
      self == .left ? .right : .left
    }
  }
}

// Retrieval
extension LocalizationSet {
  func localizationFrames(at elapsedTime: Int,
                          for duration: Int,
                          stepping direction: Step) -> [LocalizationFrame] {
    let startIndex = frameIndex(elapsedTime: elapsedTime)
    let endTime = elapsedTime + (direction == .right ? 1 : -1) * duration
    let endIndex = frameIndex(elapsedTime: endTime)
    
    let range = direction == .right ? startIndex..<endIndex : endIndex..<startIndex

    return Array(frames[range])
  }
  
  func localizations(at elapsedTime: Int,
                     for duration: Int,
                     stepping direction: Step) -> [Localization] {
    localizationFrames(at: elapsedTime,
                       for: duration,
                       stepping: direction)
    .reduce(into: [Localization]()) { acc, frame in
      acc.append(contentsOf: frame.ids.map { storage[$0]! })
    }
  }
  
  func localizations(at elapsedTime: Int) -> [Localization] {
    localizations(at: elapsedTime, for: 0, stepping: .right)
  }
}

/// Storage
extension LocalizationSet {
  mutating func add(_ localization: Localization) -> Bool {
    guard !exists(localization) else { return false }
    
    storage[localization.id] = localization
    framesInsert(localization)
    
    return true
  }
  
  mutating func clear() {
    storage.removeAll()
    frames.removeAll()
    selected.removeAll()
  }
  
  mutating func remove(id: String) -> Bool {
    guard let localization = storage[id] else { return false }
    
    storage[id] = nil
    frameRemove(localization)
    selected.remove(localization.id)

    return true
  }
    
  mutating func update(_ localization: Localization) -> Bool {
    if let existing = storage[localization.id],
       localization.elapsedTime != existing.elapsedTime {
      frameRemove(existing)
      framesInsert(localization)
    }
    storage[localization.id] = localization
    
    return true
  }
}

/// Localization frames
extension LocalizationSet {
  func frameNumber(for localization: Localization) -> Int {
    frameNumber(elapsedTime: localization.elapsedTime)
  }

  func frameNumber(elapsedTime: Int) -> Int {
    (elapsedTime - 1) / frameDuration + 1
  }
  
  private mutating func framesInsert(_ localization: Localization) {
    if frames.isEmpty {
      frames.insert(LocalizationFrame(localization, frameDuration),
                    at: 0)
    } else {
      let index = frameIndex(for: localization)
      if index == frames.count {
        frames.insert(LocalizationFrame(localization, frameDuration),
                      at: index)
      } else {
        var localizationFrame = frames[index]
      
        if localizationFrame.frameNumber == frameNumber(for: localization) {
          localizationFrame.add(localization)
          frames[index] = localizationFrame
        } else {
          frames.insert(LocalizationFrame(localization, frameDuration),
                        at: index)
        }
      }
    }
  }
  
  private mutating func frameRemove(_ localization: Localization) {
    let index = frameIndex(for: localization)
    var localizationFrame = frames[index]
    
    if localizationFrame.frameNumber == frameNumber(for: localization) {
      localizationFrame.remove(localization)
    }
  }
  
  private func frameIndex(elapsedTime: Int) -> Int {
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

  
  private func frameIndex(for localization: Localization) -> Int {
    frameIndex(elapsedTime: localization.elapsedTime)
  }
}

/// Selected
extension LocalizationSet {
  func allSelected() -> [Localization] {
    selected.map { id in
      storage[id]!
    }
  }

  mutating func clearSelected() {
    selected.removeAll()
  }
  
  mutating func select(_ id: String) -> Bool {
    guard storage[id] != nil else { return false }
    
    selected.insert(id)
    
    return true
  }
}

/// Convenience
extension LocalizationSet {
  func exists(_ localization: Localization) -> Bool {
    storage[localization.id] != nil
  }
}
