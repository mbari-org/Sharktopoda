//
//  LocalizationLayer.swift
//  Created for Sharktopoda on 10/14/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit
import AVFoundation
import SwiftUI

final class LocalizationLayer: CAShapeLayer {
  var localization: Localization?
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) not implemented")
  }
  
  override init(layer: Any) {
    if let layer = layer as? LocalizationLayer {
      localization = layer.localization
    }
    super.init(layer: layer)
  }
  
  init(for localization: Localization, videoRect: CGRect, scale: CGFloat) {
    self.localization = localization
    super.init()

//    let layerRect = rect(videoRect: videoRect, scale: scale)
    
    // Appearance
    anchorPoint = .zero
    fillColor = .clear
    frame = rect(videoRect: videoRect, scale: scale)
    isOpaque = true
    lineJoin = .round
    lineWidth = CGFloat(UserDefaults.standard.integer(forKey: PrefKeys.displayBorderSize))
//    needsDisplayOnBoundsChange = true
    path = boundsPath()
    strokeColor = Color(hex: localization.hexColor)?.cgColor
  }
  
  /// Hashable
  public override func isEqual(_ other: Any?) -> Bool {
    guard let other = other as? LocalizationLayer else { return false }
    return localization == other.localization
  }
  
  public override var hash: Int {
    var hasher = Hasher()
    localization?.hash(into: &hasher)
    return hasher.finalize()
  }
  
  func boundsPath() -> CGPath {
    CGPath(rect: CGRect(origin: .zero, size: bounds.size), transform: nil)
  }
  
  func rect(videoRect: CGRect, scale: CGFloat) -> CGRect {
    let region = localization!.region
    
    let fullHeight = videoRect.height / scale

    let size = CGSize(width: scale * region.size.width,
                      height: scale * region.size.height)
    
    let x = videoRect.origin.x + scale * region.origin.x
    let y = videoRect.origin.y + scale * (fullHeight - region.origin.y - region.size.height)
    let origin = CGPoint(x: x, y: y)

    return CGRect(origin: origin, size: size)
  }
  
  func select(_ isSelected: Bool) {
    strokeColor = isSelected
    ? UserDefaults.standard.color(forKey: PrefKeys.selectionBorderColor).cgColor
    : Color(hex: localization!.hexColor)?.cgColor
  }
  
  func delta(by delta: DeltaRect) {
    move(by: delta.origin)
    resize(by: delta.size)
  }
  
  func move(by delta: DeltaPoint) {
    guard delta != .zero else { return }

    position = position.move(by: delta)
    localization?.move(by: delta)
  }

  func resize(by delta: DeltaSize) {
    guard delta != .zero else { return }
    
    bounds = bounds.resize(by: delta)
    path = boundsPath()
    setNeedsLayout()
    localization?.resize(by: delta)
  }


}
