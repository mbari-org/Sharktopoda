//
//  ControlAll.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlAllInfo: ControlRequest {
  var command: ControlCommand
  
  func process() -> ControlResponse {
    let videoWindows = Array(UDP.sharktopodaData.videoWindows.values)
    guard !videoWindows.isEmpty else {
      return failed("No open videos")
    }
    return ControlResponseAllInfo(from: videoWindows)
  }
}
