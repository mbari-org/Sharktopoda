//
//  ControlShow.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlShow: ControlMessage {
  var command: ControlCommand
  var uuid: String
  
  func process() -> Data {
    print("CxInc handle control show: \(self)")
    return ControlResponse.ok(command)
  }
}
