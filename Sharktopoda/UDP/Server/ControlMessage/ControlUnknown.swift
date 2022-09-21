//
//  ControlUnknown.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlUnknown: ControlMessage {
  var command: ControlCommand
  
  init(from _: Data) throws {
    command = .unknown
  }
  
  func process() -> Data {
    ControlResponse.failed(command, cause: "unknown command")
  }
}
