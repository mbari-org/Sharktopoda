//
//  ControlResponseElapsed.swift
//  Created for Sharktopoda on 9/30/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlResponseElapsed: ControlResponse {
  var response: ControlCommand
  var status: ControlResponseStatus
  var elapsedTimeMillis: Int
  
  init(using playerControl: PlayerControl) {
    response = .info
    status = .ok
    elapsedTimeMillis = playerControl.currentTime
  }
}
