//
//  ClientPing.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ClientMessagePing: ClientMessage {
  var command: ClientCommand

  init() {
    self.command = .ping
  }
  
  func data() -> Data {
    try! UDPMessageCoder.encode(self)
  }
}
