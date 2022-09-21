//
//  ResponseData.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlResponse {
  static func ok(_ response: ControlCommand) -> Data {
    ResponseControlStatus(response, status: .ok).data()
  }
  
  static func failed(_ response: ControlCommand, cause: String? = nil) -> Data {
    ResponseControlStatus(response, status: .failed, cause: cause).data()
  }
}
