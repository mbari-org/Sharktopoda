//
//  ControlUpdateLocalizations.swift
//  Created for Sharktopoda on 10/8/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlUpdateLocalizations: ControlMessage {
  var command: ControlCommand
  var uuid: String
  var localizations: [ControlLocalization]
  
  func process() -> ControlResponse {
    withWindowData(id: uuid) { windowData in
      DispatchQueue.main.async { [weak windowData] in
        guard let localizationData = windowData?.localizationData else { return }
        
        let validUpdates = localizations.filter { localizationData.exists(id: $0.uuid) }
        localizationData.remove(ids: validUpdates.map { $0.uuid })
        windowData?.add(localizations: validUpdates)
      }

      return ok()
    }
  }
}
