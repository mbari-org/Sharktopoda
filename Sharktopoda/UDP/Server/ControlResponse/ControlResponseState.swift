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

  init(rate: Float, elapsedTimeMillis: Int) {
    response = .state
    status = .ok
    self.rate = rate
    state = PlayState(rate: rate)
    self.elapsedTimeMillis = elapsedTimeMillis
  }

  init(using windowData: WindowData) {
    self.init(rate: windowData.videoControl.rate,
              elapsedTimeMillis: windowData.videoAsset.millis(ofFrame: windowData.videoControl.currentFrame))
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
