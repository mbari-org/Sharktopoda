//
//  ControlRemoveLocalizations.swift
//  Created for Sharktopoda on 10/8/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import Foundation

struct ControlRemoveLocalizations: ControlRequest {
  var command: ControlCommand
  var uuid: String
  var localizations: [String]
  
  func process() -> ControlResponse {
    withLocalizations(id: uuid) { videoLocalizations in
      videoLocalizations.remove(ids: localizations)
      return ok()
    }
  }
}
