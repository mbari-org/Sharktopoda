//
//  VideoControl.swift
//  Created for Sharktopoda on 11/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import Foundation

final class PlayerControl: Identifiable, ObservableObject {
  let id: String
  let player: AVPlayer

  let fullSize: CGSize
  let seekTolerance: CMTime

  var rate: Float = 0.0
  var previousRate: Float = 1.0
  
  @Published var paused: Bool = true
  
  init(videoAsset: VideoAsset, player: AVPlayer, seekTolerance: CMTime) {
    id = videoAsset.id
    
    self.player = player
    self.seekTolerance = seekTolerance
    
    fullSize = videoAsset.fullSize
  }
  
  func canStep(_ steps: Int) -> Bool {
    guard let item = currentItem else { return false }
    return steps < 0 ? item.canStepBackward : item.canStepForward
  }

  var currentItem: AVPlayerItem? {
    player.currentItem
  }
  
  var currentTime: Int {
    player.currentItem?.currentTime().asMillis() ?? -1
  }

  func pause() {
    guard !paused else { return }
    
    DispatchQueue.main.async {
      self.player.rate = 0.0
      self.paused = true
    }
  }

  func play() {
    play(rate: previousRate)
  }
  
  func play(rate playRate: Float) {
    guard playRate != 0.0 else { return pause() }

    previousRate = playRate
    DispatchQueue.main.async {
      self.player.rate = playRate
      self.paused = false
    }
  }
  
  func seek(elapsed: Int, done: @escaping (Bool) -> Void) {
    player.pause()
    player.seek(to: CMTime.fromMillis(elapsed),
                toleranceBefore: seekTolerance,
                toleranceAfter: seekTolerance,
                completionHandler: done)
  }
  
  func step(_ steps: Int) {
    guard paused else { return }

    currentItem?.step(byCount: steps)
  }
}

extension PlayerControl {
  enum PlayDirection: Int {
    case reverse = -1
    case paused = 0
    case forward =  1
    
    func opposite() -> PlayDirection {
      if self == .paused {
        return .paused
      } else {
        return self == .reverse ? .forward : .reverse
      }
    }
  }

  var playDirection: PlayDirection {
    if paused {
      return .paused
    } else if 0 < rate {
      return .forward
    } else {
      return .reverse
    }
  }
}
