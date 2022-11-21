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
  let elapsedTimeMillis: Int
  
  func process() -> ControlResponse {
    withPlayerControl(id: uuid) { playerControl in
      playerControl.seek(elapsed: elapsedTimeMillis)
      return ok()
    }
  }
}
