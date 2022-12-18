//
//  ControlCommand.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

enum ControlCommand: String, Codable {
  case addLocalizations = "add localizations"
  case advance = "frame advance"
  case all = "request all information"
  case capture = "frame capture"
  case clearLocalizations = "clear localizations"
  case close
  case connect
  case elapsed = "request elapsed time"
  case info = "request information"
  case open
  case pause
  case ping
  case play
  case removeLocalizations = "remove localizations"
  case seek = "seek elapsed time"
  case selectLocalizations = "select localizations"
  case show
  case state = "request player state"
  case unknown
  case updateLocalizations = "update localizations"
}
