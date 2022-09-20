//
//  StatusResponse.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

enum ResponseMessageStatus: String {
  case ok
  case failed
}

struct StatusResponse : ControlResponseMessage {
  var response: ControlCommand
  let status: String
  var cause: String?
  
  init(_ response: ControlCommand, status: ResponseMessageStatus, cause: String? = nil) {
    self.response = response
    self.status = status.rawValue
    self.cause = cause
  }
  
  func jsonData() -> Data {
    try! JSONEncoder().encode(self)
  }
}
