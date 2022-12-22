//
//  Localization.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import SwiftUI

class Localization {
  let id: String
  var concept: String
  var duration: Int
  var elapsedTime: Int
  var hexColor: String
  var layer: CAShapeLayer
  var region: CGRect

  var fullSize: CGSize
  var conceptLayer: CATextLayer
  
  init(at elapsedTime: Int, with region: CGRect, layer: CAShapeLayer, fullSize: CGSize) {
    id = SharktopodaData.normalizedId()
    concept = UserDefaults.standard.string(forKey: PrefKeys.captionDefault)!
    duration = 0
    hexColor = UserDefaults.standard.hexColor(forKey: PrefKeys.displayBorderColor)
    
    self.elapsedTime = elapsedTime
    self.region = region
    self.fullSize = fullSize
    self.layer = layer

    conceptLayer = Localization.createConceptLayer(concept)
  }

  init(from controlLocalization: ControlLocalization, size: CGSize) {
    id = SharktopodaData.normalizedId(controlLocalization.uuid)
    concept = controlLocalization.concept
    duration = controlLocalization.durationMillis
    elapsedTime = controlLocalization.elapsedTimeMillis
    fullSize = size
    hexColor = controlLocalization.color
    region = CGRect(x: CGFloat(controlLocalization.x),
                    y: CGFloat(controlLocalization.y),
                    width: CGFloat(controlLocalization.width),
                    height: CGFloat(controlLocalization.height))

    let origin = CGPoint(x: region.minX,
                         y: size.height - (region.minY + region.height))
    let layerFrame = CGRect(origin: origin, size: region.size)
    let cgColor = Color(hex: hexColor)?.cgColor
    layer = CAShapeLayer(frame: layerFrame, cgColor: cgColor!)
    
    conceptLayer = Localization.createConceptLayer(concept)
  }
  
  var debugDescription: String {
    "id: \(id), concept: \(concept), time: \(elapsedTime), duration: \(duration), color: \(hexColor)"
  }
}
