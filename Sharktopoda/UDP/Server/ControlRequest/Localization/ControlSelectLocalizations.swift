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
      DispatchQueue.main.async { [weak windowData] in
        guard let windowData = windowData else { return }

        windowData.playerView.nsPlayerView.currentLocalization = nil
        windowData.localizationData.clearSelected(notifyClient: false)
        windowData.localizationData.select(ids: localizations, notifyClient: false)
        windowData.localizationData.selectedLocalizations.forEach { localization in
          windowData.playerView.displayConcept(for: localization)
        }
      }

      return ok()
    }
  }
}
