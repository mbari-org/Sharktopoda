//
//  Localization.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

class Localization: Hashable {
  var id: String
  var concept: String
  var elapsedTimeMillis: Int
  var durationMillis: Int
  var rect: CGRect
  var hexColor: String
  
  init(from controlLocalization: ControlLocalization) {
    self.id = controlLocalization.uuid
    self.concept = controlLocalization.concept
    self.elapsedTimeMillis = controlLocalization.elapsedTimeMillis
    self.durationMillis = controlLocalization.durationMillis
    self.rect = CGRect(x: controlLocalization.x, y: controlLocalization.y,
                       width: controlLocalization.width, height: controlLocalization.height)
    self.hexColor = controlLocalization.color
  }

  static func == (lhs: Localization, rhs: Localization) -> Bool {
    lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
