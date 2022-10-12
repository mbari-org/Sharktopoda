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
    rootLayer.addSublayer(playerLayer)
//    setupPlayerLayer()
  }
}
