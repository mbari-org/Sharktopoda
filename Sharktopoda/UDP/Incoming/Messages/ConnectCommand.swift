//
//  ConnectCommand.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ConnectCommand {
  struct MaybeConnectCommand: Decodable {
    let command: String
    var host: String? = nil
    var port: String? = nil
  }
  
  enum PortError: Error {
    case message(String)
  }
  
  let command: String
  let host: String
  let port: Int
  
  init(from messageData: Data) throws {
    let connectCommand = try JSONDecoder().decode(MaybeConnectCommand.self, from: messageData)
    
    self.command = connectCommand.command
    self.host = connectCommand.host ?? "localhost"
    guard let commandPort = connectCommand.port else {
      throw PortError.message("Missing port")
    }
    guard let port = Int(commandPort) else {
      throw PortError.message("Invalid port value")
    }
    self.port = port
  }
}
