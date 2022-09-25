//
//  ControlInvalid.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlInvalid: ControlRequest {
  var command: ControlCommand = .unknown
  
  var description: String {
    command.rawValue
  }

  func process() -> ControlResponse {
    ControlResponseStatus.failed(command, cause: "invalid message")
  }
}
