//
//  LocalizationLayer.swift
//  Created for Sharktopoda on 10/14/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

final class LocalizationLayer: CAShapeLayer {
  var localization: Localization
  
  init(for localization: Localization) {
    self.localization = localization
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
