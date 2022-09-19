//
//  CommandData.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
struct CommandData {
  struct Command: Decodable {
    let command: String
  }
  
  var command: String
  var data: Data
  var error: String?
  
  init(_ messageData: Data) {
    data = messageData
    do {
      let messageCommand = try JSONDecoder().decode(Command.self, from: messageData)
      command = messageCommand.command
    } catch {
      command = ""
      self.error = "Failed parsing JSON"
    }
  }
}
