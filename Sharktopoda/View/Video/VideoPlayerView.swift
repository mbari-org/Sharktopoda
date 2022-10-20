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

  private var localizations: LocalizationSet?

  private var _videoAsset: VideoAsset?
  
  init(videoAsset: VideoAsset) {
    _videoAsset = videoAsset
    localizations = LocalizationSet(frameDuration: videoAsset.frameDuration)
    let videoSize = videoAsset.size!
    super.init(frame: NSMakeRect(0, 0, videoSize.width, videoSize.height))
    setup()
  }
  
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
    
    let player = AVPlayer(url: videoAsset.url)
    playerLayer.player = player

    playerLayer.frame = bounds
    playerLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        
    rootLayer.addSublayer(playerLayer)
    
    setTimeObserver()
  }

  private var player: AVPlayer? {
    get { playerLayer.player }
  }
}

/// Computed variables
extension VideoPlayerView {
  var currentTime: Int {
    get {
      guard let currentTime = player?.currentItem?.currentTime() else { return 0 }
      return currentTime.asMillis()
    }
  }
  
  var scale: CGFloat {
    /// Player always maintains original aspect so either width or height would do here
    get {
      videoRect.size.width / videoSize.width
    }
  }
  
  var videoAsset: VideoAsset {
    get {
      _videoAsset!
    }
  }
  
  var videoRect: CGRect {
    get {
      playerLayer.videoRect
    }
  }
  
  var videoSize: CGSize {
    get {
      videoAsset.size ?? .zero
    }
  }
}

/// Localizations
extension VideoPlayerView {
  func addLocalization(_ localization: Localization) -> Bool {
    let layer = LocalizationLayer(for: localization,
                                  videoRect: videoRect,
                                  scale: scale)
    let result = localizations!.add(layer)
    
    if player!.rate == 0,
       localizations?.frameNumber(elapsedTime: currentTime) == localizations?.frameNumber(for: localization) {
      DispatchQueue.main.async { [weak self] in
        self?.playerLayer.addSublayer(layer)
      }
    }

    return result
  }

  func clearLocalizations() {
    guard var localizations = localizations else { return }
    
    clearDisplayedLocations()
    
    localizations.clear()
  }
  
  func removeLocalizations(_ ids: [String]) -> [Bool] {
    guard localizations != nil else {
      return ids.map { _ in false }
    }
    
    let result = ids.map { localizations!.remove(id: $0) }
    
    displayCurrentLocations()
    
    return result
  }
  
  func selectLocalizations(_ ids: [String]) -> [Bool] {
    guard var localizations = localizations else {
      return ids.map { _ in false }
    }

    localizations.clearSelected()
    
    return ids.map { localizations.select($0) }
  }
  
  func updateLocalization(_ localization: Localization) -> Bool {
    guard localizations != nil else { return false }

    let layer = LocalizationLayer(for: localization,
                                  videoRect: videoRect,
                                  scale: scale)
    
    let result = localizations!.update(layer)

    displayCurrentLocations()

    return result
  }
  
}

extension VideoPlayerView {
  func canStep(_ steps: Int) -> Bool {
    guard let item = player?.currentItem else {
      return false
    }
    return steps < 0 ? item.canStepBackward : item.canStepForward
  }

  func frameGrab(at captureTime: Int, destination: String) async -> FrameGrabResult {
    return await videoAsset.frameGrab(at: captureTime, destination: destination)
  }

  func pause() {
    player?.pause()
  }

  var rate: Float {
    get { player?.rate ?? Float(0) }
    set { player?.rate = newValue }
  }

  func seek(elapsed: Int) {
    /// CxTBD Should we pause here?
    pause()

    /// Within a half frame span of the target seek we'll see all the frames for the seek time
    let quarterFrame = CMTimeMultiplyByFloat64(videoAsset.frameDuration, multiplier: 0.25)
    player?.seek(to: CMTime.fromMillis(elapsed), toleranceBefore: quarterFrame, toleranceAfter: quarterFrame) { [weak self] done in
      if done {
        self?.displayCurrentLocations()
      }
    }
  }

  func step(_ steps: Int) {
    player?.currentItem?.step(byCount: steps)
    
    displayCurrentLocations()
  }
}

extension VideoPlayerView {
  
  func setTimeObserver() {
    let queue = DispatchQueue(label: "Sharktopoda Video Queue: \(videoAsset.id)")
    player?.addPeriodicTimeObserver(forInterval: videoAsset.frameDuration, queue: queue) { [weak self] time in
      self?.displayCurrentLocations()
    }
  }
}

extension VideoPlayerView {
  
  func localizationLayers() -> [LocalizationLayer] {
    return playerLayer.sublayers?.reduce(into: [LocalizationLayer]()) { acc, layer in
      if let layer = layer as? LocalizationLayer {
        acc.append(layer)
      }
    } ?? []
  }
  
  func displayCurrentLocations() {
    clearDisplayedLocations()

    /// Add current localizations
    if let layers = localizations?.layers(at: currentTime) {
      for layer in layers {
        DispatchQueue.main.async { [weak self] in
          self?.playerLayer.addSublayer(layer)
        }
      }
    }

    DispatchQueue.main.async { [weak self] in
      self?.playerLayer.setNeedsLayout()
    }
  }
  
  func clearDisplayedLocations() {
    let sublayers = localizationLayers()
    if !sublayers.isEmpty {
      DispatchQueue.main.async {
        sublayers.forEach { $0.removeFromSuperlayer() }
      }
    }
  }
  
  func resized() {
    for layer in localizationLayers() {
      let layerRect = layer.rect(videoRect: videoRect, scale: scale)
      layer.frame = layerRect
      layer.path = CGPath(rect: CGRect(origin: .zero, size: layerRect.size), transform: nil)
    }
    
//      layer.transform = CATransform3DMakeTranslation(layerRect.origin.x, layerRect.origin.y, 0)

//      if let region = layer.localization?.region {
//        let regionSize = region.size
//        let playerSize = playerLayer.videoRect.size
//        let x = regionSize.width * playerSize.width
//        let y = regionSize.height * playerSize.height
//        layer.transform = CATransform3DMakeScale(x, y, 1.0)
//      }
      

      
//      let rect = layer.rect(relativeTo: playerLayer.videoRect)
//      layer.path = CGPath(rect: CGRect(origin: .zero, size: rect.size), transform: nil)
//      layer.position(relativeTo: playerLayer.videoRect)

  }
}

