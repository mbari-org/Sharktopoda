//
//  ControlSeek.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlSeek: ControlRequest {
  var command: ControlCommand
  let uuid: String
  let elapsedTime: Int
  
  func process() -> ControlResponse {
    print("CxInc handle: \(self)")
    return ok()
  }
}
