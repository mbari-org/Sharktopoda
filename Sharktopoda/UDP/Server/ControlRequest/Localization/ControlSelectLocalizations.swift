//
//  ControlSelectLocalizations.swift
//  Created for Sharktopoda on 10/8/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlSelectLocalizations: ControlMessage {
  var command: ControlCommand
  var uuid: String
  var localizations: [String]
  
  func process() -> ControlResponse {
    withWindowData(id: uuid) { windowData in
      windowData.localizations.select(ids: localizations, notifyClient: false)
      return ok()
    }
  }
}
