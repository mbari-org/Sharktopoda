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

  var description: String {
    command.rawValue
  }

  func process() -> ControlResponse {
    ControlResponseMessage.failed(command, cause: cause)
  }
}
