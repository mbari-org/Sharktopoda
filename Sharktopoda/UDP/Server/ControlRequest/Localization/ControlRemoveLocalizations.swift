//
//  ControlRemoveLocalizations.swift
//  Created for Sharktopoda on 10/8/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import Foundation

struct ControlRemoveLocalizations: ControlMessage {
  var command: ControlCommand
  var uuid: String
  var localizations: [String]
  
  func process() -> ControlResponse {
    withWindowData(id: uuid) { windowData in
      DispatchQueue.main.async { [weak windowData] in
        windowData?.localizationData.remove(ids: localizations)
      }
      
      return ok()
    }
  }
}
