//
//  ControlResponseStatus.swift
//  Created for Sharktopoda on 10/1/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlResponseState: ControlResponse {
  var response: ControlCommand
  var status: ControlResponseStatus
  
  var rate: Float = 0.0
  var state: PlayState
  var elapsedTimeMillis: Int

  init(using windowData: WindowData) {
    response = .state
    status = .ok
    rate = windowData.videoControl.rate
    state = PlayState(rate: rate)
    elapsedTimeMillis = windowData.videoControl.currentTime
  }
}

extension ControlResponseState {
  enum PlayState: String, Codable {
    case forward = "shuttling forward"
    case paused
    case playing
    case reverse = "shuttling reverse"
    
    init(rate: Float) {
      if rate == 0.0 { self = .paused }
      else if rate == 1.0 { self = .playing }
      else if rate < 0.0 { self = .reverse }
      else { self = .forward }
    }
  }
}
