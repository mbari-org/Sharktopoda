//
//  Localization.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

struct Localization: Hashable {
  let id: String
  let concept: String
  let elapsedTime: Int
  let duration: Int
  let region: CGRect
  let hexColor: String
  
  init(from controlLocalization: ControlLocalization) {
    self.id = controlLocalization.uuid
    self.concept = controlLocalization.concept
    self.elapsedTime = controlLocalization.elapsedTimeMillis
    self.duration = controlLocalization.durationMillis
    self.region = CGRect(x: controlLocalization.x, y: controlLocalization.y,
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
}

struct OrderedLocalization: Comparable {
  let id: String
  let elapsedTime: Int
  
  init(for localization: Localization) {
    id = localization.id
    elapsedTime = localization.elapsedTime
  }
  
  // Comparable
  static func < (lhs: OrderedLocalization, rhs: OrderedLocalization) -> Bool {
    lhs.elapsedTime < rhs.elapsedTime
  }
}
