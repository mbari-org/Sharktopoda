//
//  ControlPause.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlPause: ControlMessage {
  var command: ControlCommand
  var uuid: String
  
  func process() -> ControlResponse {
    withWindowData(id: uuid) { windowData in
      DispatchQueue.main.async { [weak windowData] in
        windowData?.pause()
      }

      return ok()
    }
  }
}
