//
//  PingRequest.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct PingRequest: RequestMessage {
  var command: String

  init() {
    self.command = RequestCommand.ping.rawValue
  }
  
  func jsonData() -> Data {
    try! JSONEncoder().encode(self)
  }
}
