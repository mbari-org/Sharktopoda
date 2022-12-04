//
//  ControlUnknown.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlUnknown: ControlMessage {
  var command: ControlCommand = .unknown
  var cause: String
  
  init(_ cause: String) {
    self.cause = cause
  }

  func process() -> ControlResponse {
    failed(cause)
  }
  
  static func failed(_ cause: String) -> ControlResponse {
    ControlUnknown(cause).process()
  }
}
