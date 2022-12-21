//
//  LocalizationSelect.swift
//  Created for Sharktopoda on 12/7/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

extension Localization {
  var localizationLineWidth: CGFloat {
    CGFloat(UserDefaults.standard.integer(forKey: PrefKeys.displayBorderSize))
  }
  
  var selectedColor: CGColor {
    UserDefaults.standard.color(forKey: PrefKeys.selectionBorderColor).cgColor!
  }
  
  var selectedLineWidth: CGFloat {
    CGFloat(UserDefaults.standard.integer(forKey: PrefKeys.selectionBorderSize))
  }

  
  var localizationColor: CGColor {
    (Color(hex: hexColor)?.cgColor)!
  }

  func select() {
    layer.strokeColor = selectedColor
    layer.lineWidth = selectedLineWidth
    conceptLayer = LocalizationConcept(self).layer
  }

  func unselect() {
    layer.strokeColor = localizationColor
    layer.lineWidth = localizationLineWidth
    conceptLayer?.removeFromSuperlayer()
    conceptLayer = nil
  }
}
