//
//  OutgoingCommand.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

enum ClientCommand: String, Codable {
  case captureDone = "frame capture done"
  case openDone = "open done"
  case addLocalizations = "add localizations"
  case removeLocalizations = "remove localizations"
  case updateLocalizations = "update localizations"
  case clearLocalizations = "clear localizations"
  case selectLocalizations = "select localizations"
  case ping = "ping"
}
