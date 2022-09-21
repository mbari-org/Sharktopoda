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
  var host: String?
  let port: Int
  
  init(from messageData: Data) throws {
    let controlMessage = try JSONDecoder().decode(ControlConnect.self, from: messageData)
    
    self.command = controlMessage.command
    self.host = controlMessage.host ?? "localhost"
    self.port = controlMessage.port
  }
  
  func process() -> Data {
    UDP.client(using: self)
    return ControlResponse.ok(command)
  }
}
