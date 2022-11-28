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
    withWindowData(id: uuid) { windowData in
      let videoControl = windowData.videoControl
      let playerView = windowData.playerView
      let localizations = windowData.localizations

      videoControl.pause()
      DispatchQueue.main.async {
        localizations.clearSelected()
        playerView.clear()
      }
      
      videoControl.seek(elapsed: elapsedTimeMillis) { done in
        let pausedLocalizations = localizations.fetch(.paused, at: videoControl.currentTime)
        DispatchQueue.main.async {
          playerView.display(localizations: pausedLocalizations)
        }
      }
      return ok()
    }
  }
}
