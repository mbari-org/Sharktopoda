//
//  ClientCommandLocalizationIds.swift
//  Created for Sharktopoda on 11/11/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ClientCommandLocalizationIds: ClientMessage {
  var command: ClientCommand
  let uuid: String
  let localizations: [String]
  
  init(_ command: ClientCommand, videoId: String, ids: [String]) {
    self.command = command
    uuid = videoId
    localizations = ids
  }
  
  func data() -> Data {
    try! UDPMessageCoder.encode(self)
  }
}
