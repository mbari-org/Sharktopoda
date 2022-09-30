//
//  ControlInfo.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

struct ControlInfo: ControlRequest {
  var command: ControlCommand
  
  func process() -> ControlResponse {
    if let latestWindow = UDP.sharktopodaData.latedVideoWindow() {
      return ControlResponseInfo(from: latestWindow)
    }

    return failed("No open videos")
  }
}
