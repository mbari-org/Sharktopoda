//
//  LocalizationSelect.swift
//  Created for Sharktopoda on 12/7/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

extension Localization {
  var selectedColor: CGColor {
    UserDefaults.standard.color(forKey: PrefKeys.selectionBorderColor).cgColor!
  }
  
  var localizationColor: CGColor {
    (Color(hex: hexColor)?.cgColor)!
  }

  var captionSize: CGFloat {
    CGFloat(UserDefaults.standard.integer(forKey: PrefKeys.captionFontSize))
  }
  
  var captionColor: CGColor {
    UserDefaults.standard.color(forKey: PrefKeys.captionFontColor).cgColor!
  }
  
  func select() {
    layer.strokeColor = selectedColor
    let conceptLayer = CATextLayer()
    conceptLayer.fontSize = captionSize
    conceptLayer.foregroundColor = captionColor
    conceptLayer.alignmentMode = .left
    conceptLayer.string = concept
    conceptLayer.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 12))
    self.conceptLayer = conceptLayer
  }
  
  func positionConcept(for videoRect: CGRect) {
    guard let conceptLayer = conceptLayer else { return }
    
    let frame = layer.frame
    
    var y = frame.maxY + layer.lineWidth
    if videoRect.maxY < y + conceptLayer.frame.height {
      y = frame.minY - layer.lineWidth - conceptLayer.frame.height
    }
    let origin = CGPoint(x: frame.minX, y: y)
    
    CALayer.noAnimation {
      conceptLayer.frame = CGRect(origin: origin, size: conceptLayer.frame.size)
    }
  }

  func unselect() {
    layer.strokeColor = localizationColor
    conceptLayer?.removeFromSuperlayer()
    conceptLayer = nil
  }

}
