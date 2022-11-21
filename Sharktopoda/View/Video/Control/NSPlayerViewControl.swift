//
//  VPVControl.swift
//  Created for Sharktopoda on 10/31/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit
import AVFoundation

extension NSPlayerView {
  func canStep(_ steps: Int) -> Bool {
    guard let item = currentItem else { return false }
    return steps < 0 ? item.canStepBackward : item.canStepForward
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
  
  func frameGrab(at captureTime: Int, destination: String) async -> FrameGrabResult {
    return await videoAsset.frameGrab(at: captureTime, destination: destination)
  }
  
  func pause() {
    guard !paused else { return }
    
    player.pause()
    clearLocalizationLayers()
    displayPaused()
  }
  
  var paused: Bool {
    rate == 0.0
  }
  
  var rate: Float {
    get { player.rate }
    set {
      if paused {
        clearLocalizationLayers()
      }
      if newValue == 0.0 {
        pause()
      } else if 0 < newValue {
        displayLocalizations(.forward, at: currentTime)
      } else {
        displayLocalizations(.reverse, at: currentTime)
      }
      player.rate = newValue
    }
  }
  
  func seek(elapsed: Int) {
    guard paused else { return }
    
    clearLocalizationLayers()
    
    /// Within a half frame span of the target seek we'll see all the frames for the specified seek time
    let quarterFrame = CMTimeMultiplyByFloat64(videoAsset.frameDuration, multiplier: 0.25)
    player.seek(to: CMTime.fromMillis(elapsed), toleranceBefore: quarterFrame, toleranceAfter: quarterFrame) { [weak self] done in
      if done,
         UserDefaults.standard.bool(forKey: PrefKeys.showAnnotations) {
        self?.displayPaused()
      }
    }
  }
  
  func step(_ steps: Int) {
    guard paused else { return }
    
    clearLocalizationLayers()
    
    guard showLocalizations else { return }
    
    currentItem?.step(byCount: steps)
    displayPaused()
  }
}


