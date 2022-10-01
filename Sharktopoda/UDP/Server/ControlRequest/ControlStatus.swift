//
//  ControlStatus.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlStatus: ControlRequest {
  var command: ControlCommand
  var uuid: String
  
  func process() -> ControlResponse {
//    if let window = UDP.sharktopodaData.videoWindows[uuid] {
//          return ok()
//    }
      return failed("No video for uuid")
  }
}
