//
//  ControlResponsePing.swift
//  Created for Sharktopoda on 9/25/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlResponsePing : ControlResponse {
  var response: ControlCommand = .ping
  var status: ControlResponseCommand.Status = .ok
  
  var description: String {
    response.rawValue
  }

  func data() -> Data {
    try! JSONEncoder().encode(self)
  }
}
