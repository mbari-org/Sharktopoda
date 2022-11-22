//
//  ControlClearLocalizations.swift
//  Created for Sharktopoda on 10/8/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlClearLocalizations: ControlRequest {
  var command: ControlCommand
  var uuid: String
  
  func process() -> ControlResponse {
    withVideoWindow(id: uuid) { videoWindow in
      videoWindow.playerView.clear()
      videoWindow.localizations.clear()
      
      return ok()
    }
  }
}
