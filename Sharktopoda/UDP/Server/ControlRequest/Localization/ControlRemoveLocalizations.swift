//
//  ControlRemoveLocalizations.swift
//  Created for Sharktopoda on 10/8/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlRemoveLocalizations: ControlRequest {
  var command: ControlCommand
  var uuid: String
  var localizations: [String]
  
  func process() -> ControlResponse {
//    guard let videoWindow = UDP.sharktopodaData.videoWindows[uuid] else {
//      return failed("No video for uuid")
//    }
    
//    let _ = videoWindow.removeLocalizations(localizations)
    
//    return ok()
    return failed("CxInc")
  }
}
