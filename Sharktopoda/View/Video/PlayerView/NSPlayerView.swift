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
  
  var _playerControl: PlayerControl?
  
  private var _currentLocalization: Localization?
  
  // MARK: ctors
  init(playerControl: PlayerControl) {
    let size = playerControl.fullSize
    super.init(frame: NSMakeRect(0, 0, size.width, size.height))

    setup(playerControl)
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
  private func setup(_ playerControl: PlayerControl? = nil) {
    guard let playerControl = playerControl else { return }
    
    wantsLayer = true
    layer = rootLayer
    
    playerLayer.player = playerControl.player
    playerLayer.frame = bounds
    playerLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
    
    let conceptLayer = CATextLayer()
    conceptLayer.fontSize = CGFloat(UserDefaults.standard.integer(forKey: PrefKeys.captionFontSize))
    conceptLayer.foregroundColor = UserDefaults.standard.color(forKey: PrefKeys.captionFontColor).cgColor
    conceptLayer.alignmentMode = .left
    self.conceptLayer = conceptLayer
    
    rootLayer.addSublayer(playerLayer)
    
    _playerControl = playerControl
  }
}

// MARK: Computed properties
extension NSPlayerView {
  var currentItem: AVPlayerItem? {
    player.currentItem
  }
  
  var currentTime: Int {
    get {
      guard let currentTime = currentItem?.currentTime() else { return 0 }
      return currentTime.asMillis()
    }
  }
  
  var currentLocalization: Localization? {
    get { _currentLocalization }
    set {
      if _currentLocalization != nil {
        localizations.clearSelected()
      }
      _currentLocalization = newValue
      if newValue == nil {
        currentLocation = nil
        conceptLayer?.removeFromSuperlayer()
      }
    }
  }
  
  var fullSize: CGSize {
    playerControl.fullSize
  }
  
  // CxTBD This doesn't seem right
  var localizations: Localizations {
    UDP.sharktopodaData.localizations(id: playerControl.id)!
  }
  
  var player: AVPlayer {
    get { playerLayer.player! }
  }
  
  var playerControl: PlayerControl {
    get { _playerControl! }
  }
  
  var scale: CGFloat {
    /// Player always maintains original aspect so either width or height work here
    get {
      videoRect.size.width / playerControl.fullSize.width
    }
  }
  
  var videoRect: CGRect {
    get {
      playerLayer.videoRect
    }
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

// MARK: Display and Clear
extension NSPlayerView {

  func clear() {
    let layers = localizationLayers()
    DispatchQueue.main.async {
      layers.forEach { $0.removeFromSuperlayer() }
      self.conceptLayer?.removeFromSuperlayer()
    }
  }
  
  func clear(localizations: [Localization]) {
    DispatchQueue.main.async {
      localizations.forEach { $0.layer.removeFromSuperlayer()}
    }
  }
  
  func display(localizations: [Localization]) {
    guard showLocalizations else { return }
    
    DispatchQueue.main.async { [weak self] in
      localizations.forEach { self?.playerLayer.addSublayer($0.layer) }
    }
  }

  var showLocalizations: Bool {
    UserDefaults.standard.bool(forKey: PrefKeys.showAnnotations)
  }
}
