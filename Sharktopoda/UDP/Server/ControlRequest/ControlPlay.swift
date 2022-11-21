//
//  ControlPlay.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlPlay: ControlRequest {
  var command: ControlCommand
  let uuid: String
  @Default<Float.PlaybackRate> var rate: Float

  func process() -> ControlResponse {
    withPlayerControl(id: uuid) { playerControl in
      playerControl.play(rate: rate)
      return ok()
    }
  }
}
