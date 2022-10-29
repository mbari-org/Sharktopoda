//
//  Localization.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

class Localization: Hashable {
  let id: String
  var concept: String
  let elapsedTime: Int
  let duration: Int
  var region: CGRect
  let hexColor: String
  
  init(from controlLocalization: ControlLocalization) {
    id = controlLocalization.uuid
    concept = controlLocalization.concept
    elapsedTime = controlLocalization.elapsedTimeMillis
    duration = controlLocalization.durationMillis
    hexColor = controlLocalization.color
    
    region = CGRect(x: CGFloat(controlLocalization.x),
                    y: CGFloat(controlLocalization.y),
                    width: CGFloat(controlLocalization.width),
                    height: CGFloat(controlLocalization.height))
  }
  
  func move(by delta: CGPoint) {
    region = region.move(by: delta)
  }

  /// Hashable
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: Localization, rhs: Localization) -> Bool {
    lhs.id == rhs.id
  }
  
  ///
  var description: String {
    "id: \(id), concept: \(concept), time: \(elapsedTime), duration: \(duration), color: \(hexColor)"
  }
}
