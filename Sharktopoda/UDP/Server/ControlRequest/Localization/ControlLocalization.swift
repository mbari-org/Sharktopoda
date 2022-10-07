//
//  ControlLocalization.swift
//  Created for Sharktopoda on 10/6/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlLocalization: Decodable, CustomStringConvertible {
  var uuid: String
  var concept: String
  var elapsedTimeMillis: Int
  @Default<Int.DurationMillis> var durationMillis: Int
  var x: Int
  var y: Int
  var width: Int
  var height: Int
  @Default<String.LocalizationHexColor> var color: String

  var description: String {
    "CxInc ControlLocalization.description"
  }
}
