//
//  ControlResponseCaptureOk.swift
//  Created for Sharktopoda on 11/28/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlResponseCaptureOk : ControlResponse {
  var response: ControlCommand = .capture
  var status: ControlResponseStatus = .ok
  var captureTime: Int
  
  init(_ frameTime: Int) {
    self.captureTime = frameTime
  }
}
