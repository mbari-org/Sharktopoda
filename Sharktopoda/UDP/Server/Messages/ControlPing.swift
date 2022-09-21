//
//  ControlPing.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlPing: ControlMessage {
  var command: ControlCommand
  
  init(from _: Data) throws {
    command = .ping
  }
  
  func process() -> Data {
    ControlResponse.ok(command)
  }
}
