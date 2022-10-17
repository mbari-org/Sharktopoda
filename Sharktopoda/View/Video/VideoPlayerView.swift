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

    let layer = LocalizationLayer(for: localization, color: color, width: width)
    let layerRect = layer.rect(relativeTo: playerLayer.videoRect)
    layer.frame = layerRect
    layer.path = CGPath(rect: CGRect(origin: .zero, size: layerRect.size), transform: nil)
    
    DispatchQueue.main.async { [weak self] in
//      self?.rootLayer.addSublayer(layer)
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
    let quarterFrame = CMTime.fromMillis(videoAsset!.frameDuration / 4)
    player?.seek(to: CMTime.fromMillis(elapsed), toleranceBefore: quarterFrame, toleranceAfter: quarterFrame)
//        player?.seek(to: CMTime.fromMillis(elapsed), toleranceBefore: .zero, toleranceAfter: .zero)
  }

  func step(_ steps: Int) {
    player?.currentItem?.step(byCount: steps)
  }
}

extension VideoPlayerView {
  func resized() {
//    rootLayer.sublayers?.forEach { layer in
    playerLayer.sublayers?.forEach { layer in
      guard let layer = layer as? LocalizationLayer else { return }
      
      let layerRect = layer.rect(relativeTo: playerLayer.videoRect)
      layer.frame = layerRect
      layer.path = CGPath(rect: CGRect(origin: .zero, size: layerRect.size), transform: nil)

//      layer.transform = CATransform3DMakeTranslation(layerRect.origin.x, layerRect.origin.y, 0)
      
//      let rect = layer.rect(relativeTo: playerLayer.videoRect)
//      layer.path = CGPath(rect: CGRect(origin: .zero, size: rect.size), transform: nil)
//      layer.position(relativeTo: playerLayer.videoRect)
    }
  }
  
}
