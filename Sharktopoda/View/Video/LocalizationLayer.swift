//
//  LocalizationLayer.swift
//  Created for Sharktopoda on 10/14/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

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

  init(for localization: Localization, color: CGColor, width: CGFloat) {
    self.localization = localization
    super.init()
    
    anchorPoint = .zero
    fillColor = .clear
    lineJoin = .round
    lineWidth = width
    strokeColor = color
  }
  
  func rect(relativeTo videoRect: CGRect) -> CGRect {
    let region = localization!.region
    
    let regionSize = region.size
    let videoSize = videoRect.size
    
    let size = CGSize(width: regionSize.width * videoSize.width,
                      height: regionSize.height * videoSize.height)
    
    let regionOrigin = region.origin
    let videoOrigin = videoRect.origin
    let origin = CGPoint(x: videoOrigin.x + regionOrigin.x * videoSize.width,
                         y: videoOrigin.y + regionOrigin.y * videoSize.height - size.height)
    
    return CGRect(origin: origin, size: size)
  }
}
