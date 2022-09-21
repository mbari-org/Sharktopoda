//
//  ControlOpen.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlOpen: ControlMessage {
  var command: ControlCommand
  var uuid: String
  var url: String
  
  func process() -> Data {
    print("CxInc handle control open: \(self)")
    return ControlResponse.ok(command)
  }
}
