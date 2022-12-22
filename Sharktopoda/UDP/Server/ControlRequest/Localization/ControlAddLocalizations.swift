//
//  ControlAddLocalizations.swift
//  Created for Sharktopoda on 10/6/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlAddLocalizations: ControlMessage {
  var command: ControlCommand
  var uuid: String
  var localizations: [ControlLocalization]
  
  func process() -> ControlResponse {
    withWindowData(id: uuid) { windowData in
      DispatchQueue.main.async { [weak windowData] in
        windowData?.add(localizations: localizations)
      }
      return ok()
    }
  }
}
