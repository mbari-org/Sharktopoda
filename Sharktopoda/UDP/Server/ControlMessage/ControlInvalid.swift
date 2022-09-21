//
//  ControlInvalid.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlInvalid: ControlMessage {
  var command: ControlCommand = .unknown
  
  func process() -> Data {
    ControlResponse.failed(command, cause: "invalid message")
  }
}
