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

  var previousDirection: WindowData.PlayerDirection = .paused
  var previousSpeed: Float = 1.0
  
  init (windowData: WindowData) {
    self.windowData = windowData

    quickTolerance = CMTimeMultiplyByFloat64(windowData.videoAsset.frameDuration,
                                             multiplier: 10)
  }
  
  func canStep(_ steps: Int) -> Bool {
    guard let item = currentItem else { return false }
    return steps < 0 ? item.canStepBackward : item.canStepForward
  }

  var currentItem: AVPlayerItem? {
    player.currentItem
  }
  
  var currentTime: CMTime {
    player.currentItem?.currentTime() ?? .zero
  }

  var currentFrame: Int {
    windowData.videoAsset.frame(displayedAt: currentTime)
  }

  var currentFrameTime: CMTime {
    windowData.videoAsset.time(ofFrame: currentFrame)
  }

  func pause() {
    guard player.rate != 0 else { return }
    player.rate = 0.0
  }
  
  var paused: Bool {
    rate == 0.0
  }

  func play() {
    play(rate: previousSpeed)
  }
  
  func play(rate: Float) {
    guard rate != 0.0 else { return pause() }
    
    previousSpeed = abs(rate)
    previousDirection = 0 < rate ? .forward : .backward
    player.rate = rate
  }
  
  private var player: AVPlayer {
    windowData.player
  }
  
  var rate: Float {
    get { player.rate }
  }
  
  func reverse() {
    play(rate: -1 * previousSpeed)
  }
  
  var videoTimeScale: CMTimeScale {
    windowData.videoAsset.timescale
  }
  
  func quickSeek(to time: CMTime) {
    player.seek(to: time,
                toleranceBefore: quickTolerance,
                toleranceAfter: quickTolerance)
  }

  func frameSeek(toFrame frame: Int, done: ((Bool) -> Void)? = nil) {
    let time = windowData.videoAsset.time(ofFrame: max(0, frame))
    if let done {
      player.seek(to: time,
                  toleranceBefore: .zero,
                  toleranceAfter: .zero,
                  completionHandler: done)
    } else {
      player.seek(to: time,
                  toleranceBefore: .zero,
                  toleranceAfter: .zero)
    }
  }
  
  func frameSeek(to elapsedTime: Int) {
    frameSeek(toFrame: windowData.videoAsset.frame(forMillis: max(0, elapsedTime)))
  }
  
  func frameSeek(to time: CMTime) {
    frameSeek(toFrame: windowData.videoAsset.frame(displayedAt: time))
  }
  
  func frameSeek(to elapsedTime: Int, done: @escaping (Bool) -> Void) {
    frameSeek(toFrame: windowData.videoAsset.frame(forMillis: max(0, elapsedTime)), done: done)
  }

  func frameSeek(to time: CMTime, done: @escaping (Bool) -> Void) {
    frameSeek(toFrame: windowData.videoAsset.frame(displayedAt: time), done: done)
  }
}
