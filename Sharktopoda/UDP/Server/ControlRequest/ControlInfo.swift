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
    guard let videoWindow = UDP.sharktopodaData.latestVideoWindow() else {
      return failed("No open video for uuid")
    }

    return ControlResponseInfo(using: videoWindow)
  }
}
