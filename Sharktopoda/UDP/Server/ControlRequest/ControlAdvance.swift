//
//  ControlAdvance.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlAdvance: ControlMessage {
  var command: ControlCommand
  var uuid: String
  var direction: Int

  func process() -> ControlResponse {
    withWindowData(id: uuid) { windowData in
      windowData.pause(false)
      guard windowData.videoControl.canStep(direction) else {
        return failed("Cannot advance video in that direction")
      }
      
      DispatchQueue.main.async { [weak windowData] in
        windowData?.advance(steps: direction)
      }

      return ok()
    }
  }
}
