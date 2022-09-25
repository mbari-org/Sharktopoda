//
//  ControlPlay.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlPlay: ControlRequest {
  var command: ControlCommand
  let uuid: String
  @Default<Double.PlaybackRate> var rate: Double

  var description: String {
    command.rawValue
  }

  func process() -> ControlResponse {
    print("CxInc handle: \(self)")
    return ControlResponseCommand.ok(command)
  }
}
