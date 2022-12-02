//
//  ClientUpdateLocalizations.swift
//  Created for Sharktopoda on 11/10/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ClientMessageLocalizations: ClientMessage {
  var command: ClientCommand
  let uuid: String
  let localizations: [ClientLocalization]
  
  init(_ command: ClientCommand, videoId: String, localizations: [Localization]) {
    self.command = command
    uuid = videoId
    self.localizations = localizations.map { ClientLocalization(for: $0) }
  }
  
  func data() -> Data {
    try! UDPMessageCoder.encode(self)
  }
}
