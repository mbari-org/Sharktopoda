//
//  ControlUnknown.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlUnknown: ControlRequest {
  var command: ControlCommand = .unknown
  var cause: String

  func process() -> ControlResponse {
    ControlResponseCommand.failed(command, cause: cause)
  }
}
