//
//  ControlPing.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlPing: ControlMessage {
  var command: ControlCommand
  
  static func process(data: Data) throws -> Data {
    ControlResponse.ok(.ping)
  }
}
