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
  private var assetSize: CGSize?
  
  var firstStepTime: Int?
  
  override public init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setup()
  }
  
  required public init?(coder decoder: NSCoder) {
    super.init(coder: decoder)
    setup()
  }
  
  private func setup() {
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
        let player = AVPlayer(url: newAsset.url)
        playerLayer.player = player
        assetSize = newAsset.size
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
  func addLocalization(_ localization: Localization, color: CGColor, width: CGFloat) {
    let layer = LocalizationLayer(for: localization)
    
    layer.fillColor = .clear
    layer.frame = layerFrame(layer)
    layer.lineJoin = .round
    layer.lineWidth = width
    layer.strokeColor = color
    layer.path = CGPath(rect: localization.region, transform: nil)
    
    print("\nregion: \(localization.region)")
    print("frame: \(layer.frame)")
    
    print("CxDebug")
    layer.frame = CGRect(x: 505, y: 355, width: 50, height: 75)
    
    DispatchQueue.main.async { [weak self] in
      self?.playerLayer.addSublayer(layer)
    }
  }
}

extension VideoPlayerView {
  func canStep(_ steps: Int) -> Bool {
    guard let item = player?.currentItem else {
      return false
    }
    return steps < 0 ? item.canStepBackward : item.canStepForward
  }

  func playbackTime() -> Int {
    guard let playerTime = player?.currentItem?.currentTime() else { return 0 }
    return playerTime.asMillis()
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
    player?.seek(to: CMTime.fromMillis(elapsed), toleranceBefore: .zero, toleranceAfter: .zero)
  }

  func step(_ steps: Int) {
    player?.currentItem?.step(byCount: steps)
  }
}

extension VideoPlayerView {
  func resized() {
    for layer in playerLayer.sublayers ?? [] {
      guard let layer = layer as? LocalizationLayer else { return }
      layer.frame = layerFrame(layer)
    }
  }
  
  func layerFrame(_ layer: LocalizationLayer) -> CGRect {
    let regionOrigin = layer.localization.region.origin
    let regionSize = layer.localization.region.size

    let videoOrigin = playerLayer.videoRect.origin
    let videoSize = playerLayer.videoRect.size

    let origin = CGPoint(x: videoOrigin.x + regionOrigin.x * videoSize.width,
                         y: videoOrigin.y + regionOrigin.y * videoSize.height)
    
    let size = CGSize(width: regionSize.width * videoSize.width,
                      height: regionSize.height * videoSize.height)
    
    return CGRect(origin: origin, size: size)
  }
  
}
