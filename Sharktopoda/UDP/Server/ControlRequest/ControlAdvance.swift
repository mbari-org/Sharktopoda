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
    withWindowData(id: uuid) { windowData in
      let videoControl = windowData.videoControl
      
      videoControl.pause()
      
      guard videoControl.canStep(direction) else {
        return failed("Cannot advance video in that direction")
      }
      
      windowData.advance(steps: direction)
      
      return ok()
    }
  }
}
