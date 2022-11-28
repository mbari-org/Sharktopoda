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
      let existingLocalizations = windowData.localizations
      let fullSize = windowData.fullSize
      let playerView = windowData.playerView
      let videoControl = windowData.videoControl

      localizations
        .map { Localization(from: $0, size: fullSize) }
        .forEach {
          $0.resize(for: playerView.videoRect)
          existingLocalizations.add($0)

          guard videoControl.paused else { return }
          
          playerView.add(localization: $0)
        }
      return ok()
    }
  }
}
