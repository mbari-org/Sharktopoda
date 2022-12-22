//
//  ControlPlay.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlPlay: ControlMessage {
  var command: ControlCommand
  let uuid: String
  @Default<Float.PlaybackRate> var rate: Float

  func process() -> ControlResponse {
    withWindowData(id: uuid) { windowData in
      DispatchQueue.main.async { [weak windowData] in
        windowData?.play(rate: rate)
      }
      
      return ok()
    }
  }
}
