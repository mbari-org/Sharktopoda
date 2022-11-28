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
    withWindowData(id: uuid) { windowData in
      windowData.playerView.clear()
      windowData.localizations.clear()
      
      return ok()
    }
  }
}
