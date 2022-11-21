//
//  ControlSeek.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlSeek: ControlRequest {
  var command: ControlCommand
  let uuid: String
  let elapsedTimeMillis: Int
  
  func process() -> ControlResponse {
    withVideoWindow(id: uuid) { videoWindow in
      let playerControl = videoWindow.playerControl
      let playerView = videoWindow.playerView
      let localizations = videoWindow.localizations
      playerControl.seek(elapsed: elapsedTimeMillis) { done in
        DispatchQueue.main.async {
          localizations.clearSelected()
          // CxTBD Investigate layer flicker
          playerView.displayPaused()
        }
      }
      return ok()
    }
  }
}
