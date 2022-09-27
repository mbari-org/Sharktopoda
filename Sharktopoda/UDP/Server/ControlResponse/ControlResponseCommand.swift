//
//  StatusResponse.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlResponseCommand : ControlResponse {
  enum Status: String, Codable {
    case ok
    case failed
  }

  var response: ControlCommand
  var status: Status
  var cause: String?
    
  init(_ response: ControlCommand, status: Status, cause: String? = nil) {
    self.response = response
    self.status = status
    self.cause = cause
  }
  
  func data() -> Data {
    try! JSONEncoder().encode(self)
  }
  
  var description: String {
    response.rawValue
  }

}