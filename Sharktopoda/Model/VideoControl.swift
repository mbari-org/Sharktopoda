//
//  VideoControl.swift
//  Created for Sharktopoda on 11/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import Foundation

final class VideoControl {
  private var windowData: WindowData

  let quickTolerance: CMTime
  let frameTolerance: CMTime
  var previousRate: Float = 1.0
  
  init (windowData: WindowData) {
    self.windowData = windowData

    let quickMillis = min(windowData.videoAsset.duration.asMillis() / 500, 500)
    quickTolerance = CMTime.fromMillis(quickMillis)
    frameTolerance = CMTimeMultiplyByFloat64(windowData.frameDuration, multiplier: 0.45)
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
      self.player.rate = 0.0
    }
  }
  
  var paused: Bool {
    rate == 0.0
  }

  func play() {
    play(rate: previousRate)
  }
  
  func play(rate: Float) {
    guard rate != 0.0 else { return pause() }
    
    previousRate = rate
    DispatchQueue.main.async {
      self.player.rate = rate
    }
  }
  
  private var player: AVPlayer {
    windowData.player
  }
  
  var rate: Float {
    get { player.rate }
  }
  
  func quickSeek(to time: CMTime) {
    player.seek(to: time,
                toleranceBefore: quickTolerance,
                toleranceAfter: quickTolerance)
  }

  func frameSeek(to time: CMTime, done: @escaping (Bool) -> Void) {
    
    player.seek(to: time,
                toleranceBefore: frameTolerance,
                toleranceAfter: frameTolerance,
                completionHandler: done)
  }

  func seek(elapsedTime: Int, done: @escaping (Bool) -> Void) {
    frameSeek(to: CMTime.fromMillis(elapsedTime), done: done)
  }
}
