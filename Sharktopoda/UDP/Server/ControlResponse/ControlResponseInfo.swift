//
//  ControlResponseInfo.swift
//  Created for Sharktopoda on 9/30/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlResponseInfo: ControlResponse {
  var response: ControlCommand
  var status: ControlResponseStatus
  
  var uuid: String?
  var durationMillis: Int?
  var frameRate: Float?
  var key: Bool?
  
  init(uuid: String, durationMillis: Int, frameRate: Float, key: Bool) {
    response = .info
    status = .ok
    self.uuid = uuid
    self.durationMillis = durationMillis
    self.frameRate = frameRate
    self.key = key
  }
}
