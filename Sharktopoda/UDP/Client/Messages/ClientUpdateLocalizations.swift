//
//  ClientUpdateLocalizations.swift
//  Created for Sharktopoda on 11/10/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ClientUpdateLocalizations: ClientMessage {
  var command: ClientCommand
  let uuid: String
  let localizations: [Localization]
  
  init(videoId: String, localizations: [Localization]) {
    command = .updateLocalizations
    uuid = videoId
    self.localizations = localizations
  }
  
  func data() -> Data {
    try! UDPMessageCoder.encode(self)
  }
}
