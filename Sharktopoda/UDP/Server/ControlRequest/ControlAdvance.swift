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
    withVideoWindow(id: uuid) { videoWindow in
      let playerControl = videoWindow.playerControl
      
      guard playerControl.paused else {
        return failed("Can only advance while video paused")
      }
      guard playerControl.canStep(direction) else {
        return failed("Cannot advance video in that direction")
      }

      videoWindow.advance(steps: direction)
      
      return ok()
    }
  }
}
