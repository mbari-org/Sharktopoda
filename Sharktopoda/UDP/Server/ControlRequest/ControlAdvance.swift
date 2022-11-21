//
//  ControlAdvance.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlAdvance: ControlRequest {
  var command: ControlCommand
  var uuid: String
  var direction: Int

  func process() -> ControlResponse {
    withPlayerControl(id: uuid) { playerControl in
      guard playerControl.canStep(direction) else {
        return failed("Video cannot step in that direction")
      }
      
      playerControl.step(direction)
      return ok()
    }
  }
}
