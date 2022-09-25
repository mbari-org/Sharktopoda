//
//  ResponseData.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

enum ResponseStatus: String, Codable {
  case ok
  case failed
}

struct ControlResponseMessage {
  static func ok(_ response: ControlCommand) -> ControlResponse {
    ResponseControlStatus(response, status: .ok)
  }
  
  static func failed(_ response: ControlCommand, cause: String? = nil) -> ControlResponse {
    ResponseControlStatus(response, status: .failed, cause: cause)
  }
}
