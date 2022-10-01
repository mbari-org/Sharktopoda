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
    guard let videoWindow = UDP.sharktopodaData.videoWindows[uuid] else {
      return failed("No video for uuid")
    }
    videoWindow.seek(elapsed: elapsedTime)
    return ok()
  }
}
