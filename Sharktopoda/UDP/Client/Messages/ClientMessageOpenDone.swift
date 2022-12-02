//
//  ControlRespnseOpenDone.swift
//  Created for Sharktopoda on 11/28/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ClientMessageOpenDone: ClientMessage {
  var command: ClientCommand
  var status: ControlResponseStatus
  var uuid: String
  var cause: String?
  
  init(uuid: String, _ cause: String? = nil) {
    command = .openDone
    self.uuid = uuid

    if let cause = cause {
      status = .failed
      self.cause = cause
    } else {
      status = .ok
    }
  }
  
  func data() -> Data {
    try! UDPMessageCoder.encode(self)
  }
}
