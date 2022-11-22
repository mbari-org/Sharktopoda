//
//  ControlSelectLocalizations.swift
//  Created for Sharktopoda on 10/8/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlSelectLocalizations: ControlRequest {
  var command: ControlCommand
  var uuid: String
  var localizations: [String]
  
  func process() -> ControlResponse {
    withLocalizations(id: uuid) { videoLocalizations in
      videoLocalizations.select(ids: localizations, notifyClient: false)
      return ok()
    }
  }
}
