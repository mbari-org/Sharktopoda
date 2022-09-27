//
//  ControlConnect.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network

struct ControlConnect: ControlRequest {
  var command: ControlCommand
  @Default<String.Localhost> var host: String
  let port: Int
  
  var endpoint: String {
    "\(host):\(port)"
  }
  
  func process() -> ControlResponse {
    let client = UDP.client
    if endpoint != client.clientData.endpoint {
      UDP.connectClient(using: self)
      return ControlResponseOk(response: command)
    }
    return ControlResponseFailed(response: command, cause: "Connection not established")
  }
}
