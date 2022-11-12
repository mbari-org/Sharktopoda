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
  let rootLayer = CALayer()
  let playerLayer = AVPlayerLayer()

  var localizations: Localizations?
  // CxFuture  var undoLocalizations: [Localization]?
  
  /// Location within the current selected localization (for drag move/resize)
  var currentLocation: CGRect.Location?

  /// Frame of current selected localization
  var currentFrame: CGRect?
  
  /// Layer for displaying current location concept
  var conceptLayer: CATextLayer?
  
  /// Layer for either creating localization or selecting multiple localizations
  var dragLayer: CAShapeLayer?
  var dragPurpose: NSPlayerView.DragPurpose?

  /// Anchor point for either selecting locations or dragging current localization
  var dragAnchor: CGPoint?

  /// Queue on which off-main work is done
  var queue: DispatchQueue?
  
  private var _currentLocalization: Localization?
  private var _videoAsset: VideoAsset?
  
  // CxDebug
  var windowLayer: CALayer?
  
  // MARK: ctors
  init(videoAsset: VideoAsset) {
    let fullSize = videoAsset.size!
    
    super.init(frame: NSMakeRect(0, 0, fullSize.width, fullSize.height))

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

    let conceptLayer = CATextLayer()
    conceptLayer.fontSize = CGFloat(UserDefaults.standard.integer(forKey: PrefKeys.captionFontSize))
    conceptLayer.foregroundColor = UserDefaults.standard.color(forKey: PrefKeys.captionFontColor).cgColor
    conceptLayer.alignmentMode = .left
    self.conceptLayer = conceptLayer
    
    rootLayer.addSublayer(playerLayer)
    
    windowLayer = rootLayer.superlayer?.superlayer?.superlayer

    localizations = Localizations(videoAsset: videoAsset,
                                  frameDuration: videoAsset.frameDuration.asMillis())

    queue = DispatchQueue(label: "Sharktopoda Video Queue: \(videoAsset.id)")
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

  var currentLocalization: Localization? {
    get { _currentLocalization }
    set {
      if _currentLocalization != nil {
        localizations!.clearSelected()
      }
      _currentLocalization = newValue
      if newValue == nil {
        currentLocation = nil
        conceptLayer?.removeFromSuperlayer()
      }
    }
  }
  
  var player: AVPlayer? {
    get { playerLayer.player }
  }
  
  var scale: CGFloat {
    /// Player always maintains original aspect so either width or height work here
    get {
      videoRect.size.width / fullSize.width
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
  
  var fullSize: CGSize {
    get {
      videoAsset.size ?? .zero
    }
  }
}

// MARK: Localizations
extension NSPlayerView {
  func addLocalization(_ localization: Localization) -> Bool {
    localization.resize(for: videoRect)
    
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
    
    clearLocalizationLayers()
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
    conceptLayer?.removeFromSuperlayer()
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
}

// MARK: Resized
extension NSPlayerView {
  func resized() {
    pause()
//    guard paused else { return }
    
    /// Resize paused localizations on main queue to see immediate effect
    guard let pausedLocalizations = localizations?.fetch(.paused, at: currentTime) else { return }

    let videoRect = self.videoRect
    DispatchQueue.main.async {
      for localization in pausedLocalizations {
        localization.resize(for: videoRect)
      }
    }

    /// Resize all localizations on background queue. Although paused localizations are resized again,
    /// preventing that would be more overhead than re-resizing.
    guard let queue = queue else { return }
    guard let localizations = localizations else { return }
    queue.async {
      localizations.resize(for: videoRect)
    }
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

  func clearLocalizationLayers() {
    let layers = localizationLayers()
    DispatchQueue.main.async {
      layers.forEach { $0.removeFromSuperlayer() }
    }
    localizations?.clearSelected()
  }
}

// MARK: Player time callback
extension NSPlayerView {
  func setTimeObserver() {
    guard let queue = queue else { return }

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
