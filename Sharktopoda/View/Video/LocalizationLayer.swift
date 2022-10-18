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
  
  convenience init(for localization: Localization) {
    let width = CGFloat(UserDefaults.standard.integer(forKey: PrefKeys.displayBorderSize))
    let color = UserDefaults.standard.color(forKey: PrefKeys.displayBorderColor).cgColor!
    
    self.init(for: localization, color: color, width: width)
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
  
  /// Positioning
  func rect(relativeTo videoRect: CGRect) -> CGRect {
    let region = localization!.region
    
    let regionSize = region.size
    let playerSize = videoRect.size
    
    let size = CGSize(width: regionSize.width * playerSize.width,
                      height: regionSize.height * playerSize.height)
    
    let regionOrigin = region.origin
    let videoOrigin = videoRect.origin
    let origin = CGPoint(x: videoOrigin.x + regionOrigin.x * playerSize.width,
                         y: videoOrigin.y + regionOrigin.y * playerSize.height - size.height)
    
    return CGRect(origin: origin, size: size)
  }
}
