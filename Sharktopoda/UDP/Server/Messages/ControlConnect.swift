//
//  ControlConnect.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlConnect {
  struct MaybeControlConnect: ControlMessage {
    var command: ControlCommand
    var port: Int
    
    var host: String? = nil
  }
  
  let command: ControlCommand
  let host: String
  let port: Int
  
  init(from messageData: Data) throws {
    let connectCommand = try JSONDecoder().decode(MaybeControlConnect.self, from: messageData)
    
    self.command = connectCommand.command
    self.host = connectCommand.host ?? "localhost"
    self.port = connectCommand.port
  }
}
