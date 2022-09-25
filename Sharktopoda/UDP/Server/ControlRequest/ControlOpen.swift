//
//  ControlOpen.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlOpen: ControlRequest {
  var command: ControlCommand
  var uuid: String
  var url: String
  
  var description: String {
    command.rawValue
  }

  func process() -> ControlResponse {
    print("CxInc handle: \(self)")
    return ControlResponseStatus.ok(command)
  }
}
