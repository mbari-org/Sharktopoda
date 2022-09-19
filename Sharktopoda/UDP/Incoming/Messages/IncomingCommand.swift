//
//  IncomingCommand.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

enum IncomingCommand: String {
  case connect
  case open
  case close
  case info
  case allInfo
  case play
  case pause
  case elapsedTime
  case status
  case seek
  case advance
  case capture
  case ping
}
