//
//  ControlPause.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlPause: ControlRequest {
  var command: ControlCommand
  var uuid: String
  
  func process() -> ControlResponse {
//    guard let videoWindow = UDP.sharktopodaData.videoWindows[uuid] else {
//      return failed("No video for uuid")
//    }
//    videoWindow.pause()
//    return ok()
    
    return failed("CxInc")
  }
  
}
