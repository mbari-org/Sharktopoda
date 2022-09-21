//
//  ControlFrameAdvance.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlFrameAdvance: ControlMessage {
  var command: ControlCommand
  var uuid: String
  var direction: Int
  
  func process() -> Data {
    print("CxInc handle control frame advance: \(self)")
    return ControlResponse.ok(command)
  }
}
