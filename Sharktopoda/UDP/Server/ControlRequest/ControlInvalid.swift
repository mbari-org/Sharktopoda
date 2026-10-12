//
//  ControlInvalid.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlInvalid: ControlMessage {
  var command: ControlCommand = .unknown
  var cause: String
  
  func process() -> ControlResponse {
    UDP.log(.incoming, "invalid message format: \(cause)")
    return failed("Invalid message")
  }
}
