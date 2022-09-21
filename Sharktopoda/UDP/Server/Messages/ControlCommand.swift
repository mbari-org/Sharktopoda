//
//  ControlCommand.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

enum ControlCommand: String, Codable {
  case advance
  case allInfo
  case capture
  case close
  case connect
  case elapsedTime
  case info
  case open
  case pause
  case ping
  case play
  case playback
  case seek
  case show
  case unknown
}
