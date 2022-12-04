//
//  ControlAll.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlAllInfo: ControlMessage {
  var command: ControlCommand
  
  func process() -> ControlResponse {
    guard !UDP.sharktopodaData.videoWindows.isEmpty else {
      return failed("No open videos")
    }
    
    let videos = UDP.sharktopodaData.videoWindows.values.map {
      VideoInfo(using: $0)
    }

    return ControlResponseAllInfo(with: videos)
  }
}
