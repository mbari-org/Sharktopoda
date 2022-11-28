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
  let elapsedTimeMillis: Int
  
  func process() -> ControlResponse {
    withWindowData(id: uuid) { windowData in
      windowData.pause(false)
      windowData.seek(elapsedTime: elapsedTimeMillis)
      
      return ok()
    }
  }
}
