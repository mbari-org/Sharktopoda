//
//  LocalizationUpdate.swift
//  Created for Sharktopoda on 11/22/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

extension Localization {
  typealias TimelessUpdate = Bool
  
  func sameTime(as control: ControlLocalization) -> Bool {
    control.elapsedTimeMillis == elapsedTime && control.durationMillis == duration
  }
  
  func update(using control: ControlLocalization) {
    guard id == control.uuid else { return }
    
    concept = control.concept
    duration = control.durationMillis
    elapsedTime = control.elapsedTimeMillis
    hexColor = control.color
    region = CGRect(x: CGFloat(control.x),
                    y: CGFloat(control.y),
                    width: CGFloat(control.width),
                    height: CGFloat(control.height))
    
    layer.strokeColor = Color(hex: hexColor)?.cgColor
    
    let origin = CGPoint(x: region.origin.x,
                         y: fullSize.height - region.origin.y - region.size.height)

    CALayer.noAnimation { [weak self] in
      self?.layer.shapeFrame(origin: origin, size: self!.region.size)
    }
  }
}

