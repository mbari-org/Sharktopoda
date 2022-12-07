//
//  ControlAll.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlAllInfo: ControlMessage {
  var command: ControlCommand
  
  func process() -> ControlResponse {
    ControlResponseAllInfo(with: UDP.sharktopodaData.videoInfos())
  }
}
