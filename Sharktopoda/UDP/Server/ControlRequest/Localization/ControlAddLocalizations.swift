//
//  ControlAddLocalizations.swift
//  Created for Sharktopoda on 10/6/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlAddLocalizations: ControlRequest {
  var command: ControlCommand
  var uuid: String
  var localizations: [ControlLocalization]
  
  func process() -> ControlResponse {
    withWindowData(id: uuid) { windowData in
      windowData.add(localizations: localizations)
      return ok()
    }
  }
}
