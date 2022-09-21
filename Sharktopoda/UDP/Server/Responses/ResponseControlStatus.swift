//
//  StatusResponse.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ResponseControlStatus : ControlResponseMessage {
  var response: ControlCommand
  var status: ResponseStatus
  var cause: String?
  
  init(_ response: ControlCommand, status: ResponseStatus, cause: String? = nil) {
    self.response = response
    self.status = status
    self.cause = cause
  }
  
  func data() -> Data {
    try! JSONEncoder().encode(self)
  }
}
