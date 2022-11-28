//
//  ControlClose.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlClose: ControlRequest {
  var command: ControlCommand
  var uuid: String
  
  func process() -> ControlResponse {
    withVideoWindow(id: uuid) { videoWindow in
      DispatchQueue.main.async {
        videoWindow.close()
      }
      return ok()
    }
  }
}
