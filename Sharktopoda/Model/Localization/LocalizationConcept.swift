//
//  LocalizationConcept.swift
//  Created for Sharktopoda on 12/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

extension Localization {

  static var conceptColor: CGColor {
    UserDefaults.standard.color(forKey: PrefKeys.captionFontColor).cgColor!
  }

  static var conceptFontSize: CGFloat {
    CGFloat(UserDefaults.standard.integer(forKey: PrefKeys.captionFontSize))
  }
  
  static func createConceptLayer(_ concept: String) -> CATextLayer {
    let textLayer = CATextLayer()
    
    let conceptFont = NSFont.systemFont(ofSize: conceptFontSize)
    let maxSize = NSSize(width: CGFloat.infinity, height: 50)
    let textRect = concept.boundingRect(with: maxSize,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font: conceptFont],
                                     context: nil)
    
    textLayer.allowsFontSubpixelQuantization = true
    textLayer.font = conceptFont
    textLayer.fontSize = Localization.conceptFontSize
    textLayer.foregroundColor = Localization.conceptColor
    textLayer.alignmentMode = .left
    textLayer.string = concept
    textLayer.frame = CGRect(origin: .zero, size: textRect.size)

    return textLayer
  }
  
  func positionConceptLayer(for videoRect: CGRect) {
    let frame = layer.frame
    let halfLine = layer.lineWidth / 2
    
    var y = frame.maxY + halfLine
    if videoRect.maxY < y + conceptLayer.frame.height {
      y = frame.minY - halfLine - conceptLayer.frame.height
    }
    let origin = CGPoint(x: frame.minX, y: y)
    
    conceptLayer.frame = CGRect(origin: origin, size: conceptLayer.frame.size)
  }
}
