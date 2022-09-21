//
//  ControlCommandData.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlCommandData {
  struct MaybeControlMessage: Decodable {
    var command: ControlCommand
  }
  
  var command: ControlCommand
  var data: Data
  var error: String?
  
  init(from messageData: Data) {
    data = messageData
    do {
      let messageCommand = try JSONDecoder().decode(MaybeControlMessage.self, from: messageData)
      command = messageCommand.command
    } catch {
      command = .unknown
      self.error = "Invalid command"
    }
  }
  
  func controlMessage() throws -> ControlMessage {
    try command.controlMessage(data: data)
  }
}
