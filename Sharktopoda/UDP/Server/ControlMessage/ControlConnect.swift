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
  
  var description: String {
    command.rawValue
  }

  func process() -> Data {
    UDP.startClient(using: self)
    return ControlResponse.ok(command)
  }
}
