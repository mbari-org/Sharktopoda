//
//  ControlPlay.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlPlay: ControlMessage {
  var command: ControlCommand
  let uuid: String
  var rate: Float?
  
  init(from messageData: Data) throws {
    let controlMessage = try JSONDecoder().decode(ControlPlay.self, from: messageData)
    
    self.command = controlMessage.command
    self.uuid = controlMessage.uuid
    self.rate = controlMessage.rate ?? 1.0
  }
  
  func process() -> Data {
    print("CxInc handle control play: \(self)")

    return ControlResponse.ok(command)
  }
}
