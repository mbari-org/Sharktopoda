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
    
    var host: String? = nil
    var port: String? = nil
  }
  
  enum ControlConnectError: Error {
    case message(String)
  }
  
  let command: String
  let host: String
  let port: Int
  
  init(from messageData: Data) throws {
    let connectCommand = try JSONDecoder().decode(MaybeControlConnect.self, from: messageData)
    
    self.command = connectCommand.command.rawValue
    self.host = connectCommand.host ?? "localhost"
    guard let commandPort = connectCommand.port else {
      throw ControlConnectError.message("Missing port")
    }
    guard let port = Int(commandPort) else {
      throw ControlConnectError.message("Invalid port value")
    }
    self.port = port
  }
}
