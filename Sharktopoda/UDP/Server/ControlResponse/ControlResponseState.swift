//
//  ControlResponseStatus.swift
//  Created for Sharktopoda on 10/1/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

enum ControlResponsePlayState: String, Codable {
  case forward = "shuttling forward"
  case paused
  case playing
  case reverse = "shuttling reverse"
  
  init(rate: Float) {
    if rate < 0.0 { self = .reverse }
    else if rate == 0.0 { self = .paused }
    else if rate == 1.0 { self = .playing }
    else { self = .forward }
    }
  }


struct ControlResponseState: ControlResponse {
  var response: ControlCommand
  var status: ControlResponseStatus

  var rate: Float = 0.0
  var state: ControlResponsePlayState
  var elapsedTimeMillis: Int
  
  init(using videoWindow: VideoWindow) {
    response = .state
    status = .ok
    rate = videoWindow.rate
    state = ControlResponsePlayState(rate: rate)
    elapsedTimeMillis = videoWindow.elapsedTimeMillis()
  }
}
