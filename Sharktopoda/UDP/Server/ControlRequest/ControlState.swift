//
//  ControlStatus.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlState: ControlRequest {
  var command: ControlCommand
  var uuid: String
  
  func process() -> ControlResponse {
    withPlayerControl(id: uuid) { playerControl in
      ControlResponseState(using: playerControl)
    }
  }
}
