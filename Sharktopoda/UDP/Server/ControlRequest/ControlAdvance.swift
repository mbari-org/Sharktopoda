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
    guard let videoWindow = UDP.sharktopodaData.videoWindows[uuid] else {
      return failed("No video for uuid")
    }
    guard videoWindow.canStep(direction) else {
      return failed("Video cannot step in that direction")
    }
    videoWindow.step(direction)
    return ok()
  }
}
