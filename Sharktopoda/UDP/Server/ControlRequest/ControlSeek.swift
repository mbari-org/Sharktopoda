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

      videoWindow.pause()
      DispatchQueue.main.async {
        localizations.clearSelected()
        playerView.clear()
      }
      
      playerControl.seek(elapsed: elapsedTimeMillis) { done in
        let pausedLocalizations = localizations.fetch(.paused, at: playerControl.currentTime)
        DispatchQueue.main.async {
          playerView.display(localizations: pausedLocalizations)
        }
      }
      return ok()
    }
  }
}
