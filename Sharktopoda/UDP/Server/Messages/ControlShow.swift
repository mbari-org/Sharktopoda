//
//  ControlShow.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlShow: ControlMessage {
  var command: ControlCommand
  var uuid: String
  
  init(from messageData: Data) throws {
    let controlMessage = try JSONDecoder().decode(ControlShow.self, from: messageData)
    
    self.command = controlMessage.command
    self.uuid = controlMessage.uuid
  }
  
  func process() -> Data {
    print("CxInc handle control show: \(self)")
    return ControlResponse.ok(command)
  }
}
