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
    withVideoWindow(id: uuid) { videoWindow in
      let playerControl = videoWindow.playerControl
      let playerView = videoWindow.playerView
      
      playerView.clear()
      playerControl.play(rate: rate)
      return ok()
    }
  }
}
