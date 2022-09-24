//
//  ControlConnect.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network

struct ControlConnect: ControlMessage {
  var command: ControlCommand
  @Default<String.Localhost> var host: String
  let port: Int
  
  var endpoint: String {
    "\(host):\(port)"
  }
  
  var description: String {
    command.rawValue
  }

  func process() -> Data {
    UDP.connectClient(using: self)
    return ControlResponse.ok(command)
  }
}
