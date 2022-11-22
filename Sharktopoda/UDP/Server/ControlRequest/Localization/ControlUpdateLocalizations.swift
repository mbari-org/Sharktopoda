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
    withVideoWindow(id: uuid) { videoWindow in
      
  
      return ok()
    }
//    guard let videoWindow = UDP.sharktopodaData.videoWindows[uuid] else {
//      return failed("No video for uuid")
//    }
//
//    let _ = videoWindow.updateLocalizations(localizations)
//
//


  }
}
