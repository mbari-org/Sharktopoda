//
//  ControlInvalid.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlInvalid: ControlRequest {
  var command: ControlCommand = .unknown
  
  func process() -> ControlResponse {
    ControlResponseCommand.failed(command, cause: "invalid message")
  }
}
