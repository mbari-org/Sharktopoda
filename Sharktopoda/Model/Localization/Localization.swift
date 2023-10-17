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
  var duration: CMTime
  var time: CMTime
  var hexColor: String
  var layer: CAShapeLayer
  var region: CGRect

  var fullSize: CGSize
  var conceptLayer: CATextLayer
  
  init(at time: CMTime, with region: CGRect, layer: CAShapeLayer, fullSize: CGSize) {
    id = SharktopodaData.normalizedId()
    concept = UserDefaults.standard.string(forKey: PrefKeys.captionDefault)!
    duration = .zero
    hexColor = UserDefaults.standard.hexColor(forKey: PrefKeys.displayBorderColor)
    
    self.time = time
    self.region = region
    self.fullSize = fullSize
    self.layer = layer

    conceptLayer = Localization.createConceptLayer(concept)
  }

  init(from controlLocalization: ControlLocalization, videoAsset: VideoAsset) {
    id = SharktopodaData.normalizedId(controlLocalization.uuid)
    concept = controlLocalization.concept
    duration = CMTime.from(millis: controlLocalization.durationMillis,
                           timescale: videoAsset.timescale)
    time = CMTime.from(millis: controlLocalization.elapsedTimeMillis,
                               timescale: videoAsset.timescale)
    fullSize = videoAsset.fullSize
    hexColor = controlLocalization.color
    region = CGRect(x: CGFloat(controlLocalization.x),
                    y: CGFloat(controlLocalization.y),
                    width: CGFloat(controlLocalization.width),
                    height: CGFloat(controlLocalization.height))

    let origin = CGPoint(x: region.minX,
                         y: fullSize.height - (region.minY + region.height))
    let layerFrame = CGRect(origin: origin, size: region.size)

    let borderColor = Color(hex: hexColor)?.cgColor ?? UserDefaults.standard.color(forKey: PrefKeys.displayBorderColor).cgColor // Fixed Issue #39
    let borderSize = UserDefaults.standard.integer(forKey: PrefKeys.displayBorderSize)
    layer = CAShapeLayer(frame: layerFrame, borderColor: borderColor!, borderSize: borderSize)
    
    conceptLayer = Localization.createConceptLayer(concept)
  }
  
  var debugDescription: String {
    "id: \(id), concept: \(concept), time: \(time.millis), duration: \(duration.millis), color: \(hexColor)"
  }
}
