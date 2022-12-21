//
//  LocalizationConcept.swift
//  Created for Sharktopoda on 12/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct LocalizationConcept {
  let layer: CATextLayer
  
  var conceptFontSize: CGFloat {
    CGFloat(UserDefaults.standard.integer(forKey: PrefKeys.captionFontSize))
  }
  
  var conceptColor: CGColor {
    UserDefaults.standard.color(forKey: PrefKeys.captionFontColor).cgColor!
  }
  
  init(_ localization: Localization) {
    layer = CATextLayer()
    
    let conceptFont = NSFont.systemFont(ofSize: conceptFontSize)
    let maxSize = NSSize(width: localization.layer.frame.width, height: 50)
    let textRect = localization.concept.boundingRect(with: maxSize,
                                                     options: .usesLineFragmentOrigin,
                                                     attributes: [NSAttributedString.Key.font: conceptFont],
                                                     context: nil)

    layer.allowsFontSubpixelQuantization = true
    layer.font = conceptFont
    layer.fontSize = conceptFontSize
    layer.foregroundColor = conceptColor
    layer.alignmentMode = .left
    layer.string = localization.concept
    layer.frame = CGRect(origin: .zero, size: textRect.size)
  }
}
