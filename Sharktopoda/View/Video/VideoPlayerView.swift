//
//  VideoPlayerView.swift
//  Created for Sharktopoda on 10/12/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit
import AVFoundation

final class VideoPlayerView: NSView {
  
  private let rootLayer = CALayer()
  private let playerLayer = AVPlayerLayer()
  
  private var videoAsset: VideoAsset?

  override public init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setupLayers()
  }
  
  required public init?(coder decoder: NSCoder) {
    super.init(coder: decoder)
    setupLayers()
  }
  
  private func setupLayers() {
    wantsLayer = true
    layer = rootLayer
    
    playerLayer.frame = bounds
    playerLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        
    rootLayer.addSublayer(playerLayer)
  }
  
  var asset: VideoAsset? {
    get { return videoAsset }
    set {
      videoAsset = newValue
      
      if let newAsset = newValue {
        playerLayer.player = AVPlayer(url: newAsset.url)
      } else {
        playerLayer.player = nil
      }
    }
  }
}
