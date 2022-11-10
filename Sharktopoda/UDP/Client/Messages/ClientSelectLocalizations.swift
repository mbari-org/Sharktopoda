//
//  ClientSelectLocalizations.swift
//  Created for Sharktopoda on 11/10/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ClientSelectLocalizations: ClientMessage {
  var command: ClientCommand
  let uuid: String
  let localizations: [String]
  
  init(videoId: String, ids: [String]) {
    command = .selectLocalizations
    uuid = videoId
    localizations = ids
  }
  
  func data() -> Data {
    try! UDPMessageCoder.encode(self)
  }
}
