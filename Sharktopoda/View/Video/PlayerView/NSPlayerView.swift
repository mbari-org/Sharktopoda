//
//  VideoPlayerView.swift
//  Created for Sharktopoda on 10/12/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit
import AVFoundation

final class NSPlayerView: NSView {
  // MARK: properties
  private let rootLayer = CALayer()
  private let playerLayer = AVPlayerLayer()

  var localizations: Localizations?
  var undoLocalizations: [Localization]?
  var editLocation: CGRect.Location?
  
  private var _editLocalization: Localization?
  private var _videoAsset: VideoAsset?

  // MARK: ctors
  init(videoAsset: VideoAsset) {
    let videoSize = videoAsset.size!
    super.init(frame: NSMakeRect(0, 0, videoSize.width, videoSize.height))

    _videoAsset = videoAsset
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
  
  // MARK: setup
  private func setup() {
    wantsLayer = true
    layer = rootLayer
    
    let player = AVPlayer(url: videoAsset.url)
    playerLayer.player = player
    playerLayer.frame = bounds
    playerLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        
    rootLayer.addSublayer(playerLayer)

    localizations = Localizations(playerItem: currentItem!,
                                  frameDuration: videoAsset.frameDuration.asMillis())

    setTimeObserver()
  }
}

// MARK: Enums
extension NSPlayerView {
  enum PlayDirection: Int {
    case reverse = -1
    case paused = 0
    case forward =  1
    
    func opposite() -> PlayDirection {
      if self == .paused {
        return .paused
      } else {
        return self == .reverse ? .forward : .reverse
      }
    }
  }
}

// MARK: Computed properties
extension NSPlayerView {
  var currentItem: AVPlayerItem? {
    player?.currentItem
  }
  
  var currentTime: Int {
    get {
      guard let currentTime = currentItem?.currentTime() else { return 0 }
      return currentTime.asMillis()
    }
  }
  
  var showLocalizations: Bool {
    UserDefaults.standard.bool(forKey: PrefKeys.showAnnotations)
  }

  var editLocalization: Localization? {
    get { _editLocalization }
    set {
      editLocation = nil
      
      if _editLocalization != nil {
        localizations!.clearSelected()
      }
      _editLocalization = newValue
    }
  }
  
  var player: AVPlayer? {
    get { playerLayer.player }
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

// MARK: Localizations
extension NSPlayerView {
  func addLocalization(_ localization: Localization) -> Bool {
    localization.setup(for: videoRect, at: scale)
    
    guard let localizations = localizations,
          localizations.add(localization) else { return false }

    guard paused else { return true }
    
    let currentFrameNumber = localizations.frameNumber(elapsedTime: currentTime)
    let localizationFrameNumber = localizations.frameNumber(for: localization)
    
    if showLocalizations,
      currentFrameNumber == localizationFrameNumber {
      DispatchQueue.main.async { [weak self] in
        self?.playerLayer.addSublayer(localization.layer)
      }
    }

    return true
  }

  func clearLocalizations() {
    guard let localizations = localizations else { return }
    
    clearPause()
    
    localizations.clear()
  }
  
  func removeLocalizations(_ ids: [String]) -> [Bool] {
    guard localizations != nil else {
      return ids.map { _ in false }
    }
    
    let result = ids.map { localizations!.remove(id: $0) }
    
    displayPaused()
    
    return result
  }
  
  func deleteSelected() -> Bool {
    guard let localizations = localizations else { return false }
    return localizations.deleteSelected()
  }
  
  func selectLocalizations(_ ids: [String]) -> [Bool] {
    guard let localizations = localizations else {
      return Array(repeating: false, count: ids.count)
    }
    
    return localizations.select(ids: ids)
  }
  
  func updateLocalization(_ control: ControlLocalization) -> Bool {
    guard localizations != nil else { return false }
    let result = localizations!.update(using: control)
//    localization.setup(for: videoRect, at: scale)

    displayPaused()
    
    return result
  }
}

// MARK: Abstract layers
extension NSPlayerView {
  func localizationLayers() -> [CAShapeLayer] {
    return playerLayer.sublayers?.reduce(into: [CAShapeLayer]()) { acc, layer in
      if let layer = layer as? CAShapeLayer {
        acc.append(layer)
      }
    } ?? []
  }

}

// MARK: Pause layers
extension NSPlayerView {
  func displayPaused() {
    displayLocalizations(.paused, at: currentTime)
  }
  
  func clearPause() {
    clearAllLocalizations()
  }
  
  func resized() {
    guard paused else { return }
    
//    for layer in localizationLayers() {
//      let layerRect = layer.rect(videoRect: videoRect, scale: scale)
//      layer.frame = layerRect
//      layer.path = CGPath(rect: CGRect(origin: .zero, size: layerRect.size), transform: nil)
//    }
  }
}

// MARK: Display and Clear
extension NSPlayerView {
  func displayLocalizations(_ direction: PlayDirection, at elapsedTime: Int) {
    guard showLocalizations else { return }
    guard let localizations = localizations?.fetch(direction, at: elapsedTime) else { return }
    
    DispatchQueue.main.async { [weak self] in
      localizations.forEach { self?.playerLayer.addSublayer($0.layer) }
    }
  }
  
  func clearLocalizations(_ direction: PlayDirection, at elapsedTime: Int) {
    guard let fetched = localizations?.fetch(direction, at: elapsedTime) else { return }
    let layers = fetched.map { $0.layer }

    DispatchQueue.main.async {
      layers.forEach { $0.removeFromSuperlayer() }
    }
  }

  func clearAllLocalizations() {
    let layers = localizationLayers()
    DispatchQueue.main.async {
      layers.forEach { $0.removeFromSuperlayer() }
    }
  }
}

// MARK: Player time callback
extension NSPlayerView {
  func setTimeObserver() {
    let queue = DispatchQueue(label: "Sharktopoda Video Queue: \(videoAsset.id)")
    let interval = CMTimeMultiplyByFloat64(videoAsset.frameDuration, multiplier: 0.9)
    
    player?.addPeriodicTimeObserver(forInterval: interval, queue: queue) { [weak self] time in
      guard UserDefaults.standard.bool(forKey: PrefKeys.showAnnotations) else { return }

      guard let direction = self?.playDirection else { return }
      
      let elapsedTime = time.asMillis()
      let opposite = direction.opposite()
      
      self?.displayLocalizations(direction, at: elapsedTime)
      self?.clearLocalizations(opposite, at: elapsedTime)
    }
  }
}
