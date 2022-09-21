//
//  ControlSeek.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlSeek: ControlMessage {
  var command: ControlCommand
  let uuid: String
  let elapsedTime: Int
  
  func process() -> Data {
    print("CxInc handle: \(self)")
    return ControlResponse.ok(command)
  }
}
