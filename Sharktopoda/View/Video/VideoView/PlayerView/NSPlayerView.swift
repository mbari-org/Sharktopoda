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
  var _windowData: WindowData? = nil
  
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
  
  var windowData: WindowData {
    get { _windowData! }
    set { attach(windowData: newValue) }
  }
  
  private var _currentLocalization: Localization?
  
  override public init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
  }
  
  required public init?(coder decoder: NSCoder) {
    super.init(coder: decoder)
  }
  
  // MARK: setup
  private func attach(windowData: WindowData) {
    wantsLayer = true
    layer = rootLayer
    
    let size = windowData.fullSize
    frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

    playerLayer.player = windowData.player
    playerLayer.frame = bounds
    playerLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
    
    let conceptLayer = CATextLayer()
    conceptLayer.fontSize = CGFloat(UserDefaults.standard.integer(forKey: PrefKeys.captionFontSize))
    conceptLayer.foregroundColor = UserDefaults.standard.color(forKey: PrefKeys.captionFontColor).cgColor
    conceptLayer.alignmentMode = .left
    self.conceptLayer = conceptLayer
    
    rootLayer.addSublayer(playerLayer)
    
    _windowData = windowData
  }
}

// MARK: Computed properties
extension NSPlayerView {
  var currentItem: AVPlayerItem? {
    windowData.videoControl.currentItem
  }
  
  var currentTime: Int {
    windowData.videoControl.currentTime
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
    windowData.fullSize
  }
  
  // CxTBD This doesn't seem right
  var localizations: LocalizationData {
    windowData.localizations
  }

  var scale: CGFloat {
    /// Player always maintains original aspect so either width or height work here
    get {
      videoRect.size.width / fullSize.width
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
    DispatchQueue.main.async { [weak self] in
      layers.forEach { $0.removeFromSuperlayer() }
      self?.conceptLayer?.removeFromSuperlayer()
    }
  }
  
  func clear(localizations: [Localization]) {
    DispatchQueue.main.async { [weak self] in
      localizations.forEach {
        $0.layer.removeFromSuperlayer()
      }
      self?.conceptLayer?.removeFromSuperlayer()
    }
  }
  
  func display(localization: Localization) {
    guard showLocalizations else { return }
    
    DispatchQueue.main.async { [weak self] in
      self?.playerLayer.addSublayer(localization.layer)
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
