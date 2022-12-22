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
    withVideoWindow(id: uuid) { videoWindow in
      DispatchQueue.main.async { [weak videoWindow] in
        videoWindow?.windowData.play(rate: rate)
      }

      return ok()
    }
  }
}
