//
//  ControlUpdateLocalizations.swift
//  Created for Sharktopoda on 10/8/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlUpdateLocalizations: ControlRequest {
  var command: ControlCommand
  var uuid: String
  var localizations: [ControlLocalization]
  
  func process() -> ControlResponse {
    withLocalizations(id: uuid) { videoLocalizations in
      localizations
        .forEach { controlLocalization in
          videoLocalizations.update(using: controlLocalization)
        }
      return ok()
    }
  }
}
