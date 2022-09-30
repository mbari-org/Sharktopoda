//
//  ControlResponseElapsed.swift
//  Created for Sharktopoda on 9/30/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlResponseElapsed: ControlResponse {
  var response: ControlCommand
  var status: ControlResponseStatus = .failed
  var elapsedTimeMillies: Int
  
  init(from videoWindow: VideoWindow) {
    response = .info
    status = .ok
    elapsedTimeMillies = videoWindow.elapsed()
  }
}
