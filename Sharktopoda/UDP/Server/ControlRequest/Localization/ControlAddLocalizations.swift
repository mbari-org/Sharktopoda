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
    withVideoWindow(id: uuid) { videoWindow in
      let existingLocalizations = videoWindow.localizations
      let fullSize = videoWindow.videoAsset.fullSize
      let playerControl = videoWindow.playerControl
      let playerView = videoWindow.playerView
      
      localizations
        .map { Localization(from: $0, with: fullSize) }
        .forEach {
          $0.resize(for: playerView.videoRect)
          existingLocalizations.add($0)

          guard playerControl.paused else { return }
          
//          playerView.addLocalization($0, time: <#T##Int#>)
        }
      return ok()
    }
  }
}
