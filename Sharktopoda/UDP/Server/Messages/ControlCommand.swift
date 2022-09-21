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
  
  func controlMessage(data: Data) throws -> ControlMessage {
    var controlMessageType: ControlMessage.Type
    switch self {
      case .close:
        controlMessageType = ControlClose.self
        
      case .connect:
        controlMessageType = ControlConnect.self
        
      case .open:
        controlMessageType = ControlOpen.self
        
      case .pause:
        controlMessageType = ControlPause.self
        
      case .play:
        controlMessageType = ControlPlay.self
        
      case .ping:
        controlMessageType = ControlPing.self
        
      case .show:
        controlMessageType = ControlShow.self
        
      default:
        controlMessageType = ControlUnknown.self
    }

    return try JSONDecoder().decode(controlMessageType, from: data)
  }
}
