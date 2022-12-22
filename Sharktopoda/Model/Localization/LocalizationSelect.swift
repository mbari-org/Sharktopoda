//
//  LocalizationSelect.swift
//  Created for Sharktopoda on 12/7/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

extension Localization {
  var localizationColor: CGColor {
    (Color(hex: hexColor)?.cgColor)!
  }
  
  var localizationLineWidth: CGFloat {
    CGFloat(UserDefaults.standard.integer(forKey: PrefKeys.displayBorderSize))
  }
  
  var selectedColor: CGColor {
    UserDefaults.standard.color(forKey: PrefKeys.selectionBorderColor).cgColor!
  }
  
  var selectedLineWidth: CGFloat {
    CGFloat(UserDefaults.standard.integer(forKey: PrefKeys.selectionBorderSize))
  }

  func select() {
    layer.strokeColor = selectedColor
    layer.lineWidth = selectedLineWidth
  }

  func unselect() {
    layer.strokeColor = localizationColor
    layer.lineWidth = localizationLineWidth
  }
}
