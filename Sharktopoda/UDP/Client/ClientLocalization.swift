//
//  ClientLocalization.swift
//  Created for Sharktopoda on 11/11/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ClientLocalization: Codable {
  let uuid: String
  let concept: String
  let durationMillis: Int
  let elapsedTimeMillis: Int
  let x: Int
  let y: Int
  let width: Int
  let height: Int
  let color: String

  init(for localization: Localization) {
    uuid = localization.id
    concept = localization.concept
    durationMillis = localization.duration.millis
    elapsedTimeMillis = localization.time.millis
    x = Int(localization.region.minX)
    y = Int(localization.region.minY)
    width = Int(localization.region.width)
    height = Int(localization.region.height)
    color = localization.hexColor
  }
}
