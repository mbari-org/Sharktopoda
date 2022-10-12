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
  
  private var asset: VideoAsset?

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
  
  var videoAsset: VideoAsset? {
    get { return asset }
    set {
      asset = newValue
      
      if let newAsset = newValue {
        playerLayer.player = AVPlayer(url: newAsset.url)
      } else {
        playerLayer.player = nil
      }
    }
  }
  
  private var player: AVPlayer? {
    get { playerLayer.player }
  }
  
}

extension VideoPlayerView {
  func canStep(_ steps: Int) -> Bool {
    guard let item = player?.currentItem else {
      return false
    }
    return steps < 0 ? item.canStepBackward : item.canStepForward
  }

  func elapsedTimeMillis() -> Int {
    guard let currentTime = player?.currentItem?.currentTime() else { return 0 }
    return currentTime.asMillis()
  }

  func frameGrab(at captureTime: Int, destination: String) async -> FrameGrabResult {
    guard videoAsset != nil else { return FrameGrabResult.failure(VideoPlayerError.noAsset)}

    return await videoAsset!.frameGrab(at: captureTime, destination: destination)
  }

  func pause() {
    player?.pause()
  }

  var rate: Float {
    get { player?.rate ?? Float(0) }
    set { player?.rate = newValue }
  }

  func seek(elapsed: Int) {
    player?.seek(to: CMTime.fromMillis(elapsed))
  }

  func step(_ steps: Int) {
    player?.currentItem?.step(byCount: steps)
  }
}

enum VideoPlayerError: Error {
  case noAsset
  
  var description: String {
    switch self {
      case .noAsset:
        return "Video Player asset not set"
    }
  }
  
  var localizedDescription: String {
    self.description
  }
}
