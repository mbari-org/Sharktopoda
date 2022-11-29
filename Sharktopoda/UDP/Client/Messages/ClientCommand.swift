//
//  OutgoingCommand.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

enum ClientCommand: String, Codable {
  case captureDone = "frame capture done"
  case openDone = "open"
  case addLocalizations
  case removeLocalizations
  case updateLocalizations
  case clearLocalizations
  case selectLocalizations
  case ping
}
