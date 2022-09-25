//
//  StatusResponse.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

enum ResponseStatus: String, Codable {
  case ok
  case failed
}

struct ControlResponseStatus : ControlResponse {
  var response: ControlCommand
  var status: ResponseStatus
  var cause: String?
  
  static func ok(_ response: ControlCommand) -> ControlResponse {
    ControlResponseStatus(response, status: .ok)
  }
  
  static func failed(_ response: ControlCommand, cause: String? = nil) -> ControlResponse {
    ControlResponseStatus(response, status: .failed, cause: cause)
  }
  
  init(_ response: ControlCommand, status: ResponseStatus, cause: String? = nil) {
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
