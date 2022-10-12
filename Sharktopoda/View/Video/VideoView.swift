//
//  VideoView.swift
//  Created for Sharktopoda on 9/29/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI
import AVKit
import AVFoundation
import UniformTypeIdentifiers

struct VideoView: View {
  var videoAsset: VideoAsset
  let avPlayer: AVPlayer
  let videoPlayerView: VideoPlayerView
  
  var localizations = LocalizationSet()
  
  init(videoAsset: VideoAsset) {
    self.videoAsset = videoAsset
    
    avPlayer = AVPlayer(url: videoAsset.url)
    videoPlayerView = VideoPlayerView(for: avPlayer)
    videoPlayerView.avPlayerView.controlsStyle = .inline
  }
  
  var body: some View {
    videoPlayerView
    // CxTBD Could this hold a custom control panel w/ .inline changed to .none
  }
}

extension VideoView {
  func canStep(_ steps: Int) -> Bool {
    guard let item = avPlayer.currentItem else {
      return false
    }
    return steps < 0 ? item.canStepBackward : item.canStepForward
  }
  
  func elapsedTimeMillis() -> Int {
    guard let currentTime = avPlayer.currentItem?.currentTime() else { return 0 }
    return currentTime.asMillis()
  }
  
  func frameGrab(at captureTime: Int, destination: String) async -> FrameGrabResult {
    await videoAsset.frameGrab(at: captureTime, destination: destination)
  }

  func fullSize() -> NSSize {
    let videoSize = self.videoAsset.size ?? NSMakeSize(600, 600)
    return NSMakeSize(videoSize.width, videoSize.height + 110)
  }
  
  func pause() {
    avPlayer.pause()
  }
  
  var rate: Float {
    get { avPlayer.rate }
    set { avPlayer.rate = newValue }
  }
  
  func seek(elapsed: Int) {
    avPlayer.seek(to: CMTime.fromMillis(elapsed))
  }
  
  func step(_ steps: Int) {
    avPlayer.currentItem?.step(byCount: steps)
  }
}

// Localizations
extension VideoView {
  
  mutating func addLocalizations(_ localizationsToAdd: [Localization]) -> [Bool] {
    let added = localizationsToAdd.map { localization in
      localizations.add(localization)
    }
    
    let width = UserDefaults.standard.integer(forKey: PrefKeys.displayBorderSize)
    let color = UserDefaults.standard.color(forKey: PrefKeys.displayBorderColor)
    
    for (index, localization) in localizationsToAdd.enumerated() {
      if added[index] {
        let layer = localizationLayer(localization, width: width, color: color)
        avPlayerLayer.addSublayer(layer)
      }
    }
    
    return added
  }
  
  mutating func clearLocalizations() {
    localizations.clear()
  }
  
  func localizations(at elapsedTime: Int,
                     for duration: Int,
                     stepping direction: LocalizationSet.Step) -> [Localization] {
    localizations.localizations(at: elapsedTime, for: duration, stepping: direction)
  }
  
  mutating func removeLocalizations(_ localizationIds: [String]) -> [Bool] {
    localizationIds.map { id in
      localizations.remove(id: id)
    }
  }
  
  func selectedLocalizations() -> [Localization] {
    localizations.allSelected()
  }
  
  mutating func selectLocalizations(_ localizationIds: [String]) -> [Bool] {
    localizations.clearSelected()
    
    return localizationIds.map { id in
      localizations.select(id)
    }
  }
  
  mutating func updateLocalizations(_ updatedLocalizations: [Localization]) -> [Bool] {
    updatedLocalizations.map { localization in
      localizations.update(localization)
    }
  }
}

/// Localiztion layer
extension VideoView {
  func localizationLayer(_ localization: Localization, width: Int, color: Color) -> CAShapeLayer {
    let layer = CAShapeLayer()
    layer.strokeColor = color.cgColor

    layer.path = CGPath(rect: localization.location, transform: nil)

//    let path = NSBezierPath(rect: localization.location)
//    path.lineWidth = CGFloat(width)
 
//    layer.path = path
    
    return layer
  }
}
