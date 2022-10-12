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
  let videoPlayerView: Video_Player_View
  
  init(videoAsset: VideoAsset) {
    self.videoAsset = videoAsset
    
    avPlayer = AVPlayer(url: videoAsset.url)
    videoPlayerView = Video_Player_View(for: avPlayer)
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

  func videoSize() -> NSSize {
    if let videoSize = self.videoAsset.size {
      return NSMakeSize(videoSize.width, videoSize.height)
    }
    return NSMakeSize(600, 600)
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
