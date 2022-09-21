//
//  ControlInfo.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlInfo: ControlMessage {
  var command: ControlCommand
  
  func process() -> Data {
    print("CxInc handle control info (of active video): \(self)")
    return ControlResponse.ok(command)
  }
}
