//
//  ControlOpen.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlOpen: ControlMessage {
  var command: ControlCommand
  var uuid: String
  var url: String
  
  init(from messageData: Data) throws {
    let controlMessage = try JSONDecoder().decode(ControlOpen.self, from: messageData)

    self.command = controlMessage.command
    self.uuid = controlMessage.uuid
    self.url = controlMessage.url
  }
}
