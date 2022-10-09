//
//  Localization.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

// CxTBD Investigate Localization struct vs class.

class Localization: Comparable, Hashable {
  let id: String
  let concept: String
  let elapsedTimeMillis: Int
  let durationMillis: Int
  let rect: CGRect
  let hexColor: String
  
  init(from controlLocalization: ControlLocalization) {
    self.id = controlLocalization.uuid
    self.concept = controlLocalization.concept
    self.elapsedTimeMillis = controlLocalization.elapsedTimeMillis
    self.durationMillis = controlLocalization.durationMillis
    self.rect = CGRect(x: controlLocalization.x, y: controlLocalization.y,
                       width: controlLocalization.width, height: controlLocalization.height)
    self.hexColor = controlLocalization.color
  }

  // Hashable
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: Localization, rhs: Localization) -> Bool {
    lhs.id == rhs.id
  }

  // Comparable
  static func < (lhs: Localization, rhs: Localization) -> Bool {
    lhs.elapsedTimeMillis < rhs.elapsedTimeMillis
  }
  
}
