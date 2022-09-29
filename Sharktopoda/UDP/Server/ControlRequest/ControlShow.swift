//
//  ControlShow.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlShow: ControlRequest {
  var command: ControlCommand
  var uuid: String
  
  var description: String {
    "\(command) \(uuid)"
  }
  
  func process() -> ControlResponse {
    if let window = UDP.sharktopodaData.videoWindows[uuid] {
      DispatchQueue.main.async {
        window.makeKeyAndOrderFront(nil)
      }
    return ok()
    }
    return failed("video not open")
  }
}
