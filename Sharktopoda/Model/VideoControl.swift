//
//  VideoControl.swift
//  Created for Sharktopoda on 11/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import Foundation

final class VideoControl: Identifiable, ObservableObject {
  private var windowData: WindowData

  let seekTolerance: CMTime
  var previousRate: Float = 1.0
  
  @Published var playerTime: Int = 0
  @Published var playerDirection: PlayerDirection = .paused

  init (windowData: WindowData) {
    self.windowData = windowData
    
    seekTolerance = CMTimeMultiplyByFloat64(windowData.frameDuration, multiplier: 0.25)
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
    guard player.rate != 0 else { return }

    DispatchQueue.main.async {
      self.playerView.clear()
      self.playerView.display(localizations: self.pausedLocalizations())
    }
    
    DispatchQueue.main.async {
      self.player.rate = 0.0
    }
  }
  
  var paused: Bool {
    playerDirection == .paused
  }

  func play() {
    play(rate: previousRate)
  }
  
  func play(rate: Float) {
    guard rate != 0.0 else { return pause() }
    
    if playerDirection == .paused {
      DispatchQueue.main.async {
        self.playerView.clear(localizations: self.pausedLocalizations())
      }
    }

    previousRate = rate
    DispatchQueue.main.async {
      self.rate = rate
    }
  }
  
  var player: AVPlayer {
    windowData.player
  }
  
  var playerView: PlayerView {
    windowData.playerView
  }
  
  var previousDirection: PlayerDirection {
    PlayerDirection.direction(rate: previousRate)
  }
  
  var rate: Float {
    get { player.rate }
    set {
      if newValue == 0.0 {
        playerDirection = .paused
      } else if 0 < newValue {
        playerDirection = .forward
      } else {
        playerDirection = .reverse
      }
      player.rate = newValue
    }
   }
  
  func reverse() {
    play(rate: -1 * previousRate)
  }
  
  func seek(elapsed: Int, done: @escaping (Bool) -> Void) {
    self.pause()
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

extension VideoControl {
  enum PlayerDirection: Int {
    case reverse = -1
    case paused = 0
    case forward =  1
    
    static func direction(rate: Float) -> PlayerDirection {
      if rate == 0.0 {
        return .paused
      } else if 0 < rate {
        return .forward
      } else {
        return .reverse
      }
    }
    
    func opposite() -> PlayerDirection {
      if self == .paused {
        return .paused
      } else {
        return self == .reverse ? .forward : .reverse
      }
    }
  }
}

extension VideoControl {
  func pausedLocalizations() -> [Localization] {
    guard paused else { return [] }
    return windowData.localizations.fetch(.paused, at: currentTime)
  }

}
