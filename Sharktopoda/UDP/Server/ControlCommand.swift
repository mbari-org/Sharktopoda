//
//  ControlCommand.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

// CxInc add control localization commands

enum ControlCommand: String, Codable {
  case advance = "frame advance"
  case all = "request all information"
  case capture = "frame capture"
  case captureDone = "frame capture done"
  case close
  case connect
  case elapsed = "request elapsed time"
  case info = "request information"
  case open
  case pause
  case ping
  case play
  case seek = "seek elapsed time"
  case show
  case state = "request state"
  case unknown
  
  struct ControlMessageCommand: Decodable {
    var command: String
  }
  
  static func controlMessage(from data: Data) -> ControlRequest {
    // Ensure control command is valid
    var controlCommand: ControlCommand
    do {
      // Ensure message has command field
      let controlMessageCommand = try UDPMessageCoder.decode(ControlMessageCommand.self, from: data)

      // Ensure command is known
      let rawCommand = controlMessageCommand.command
      guard let maybeControlCommand = ControlCommand(rawValue: rawCommand) else {
        return ControlUnknown("unknown command: \(rawCommand)")
      }
      controlCommand = maybeControlCommand
    }
    catch {
      return ControlInvalid()
    }
    
    do {
      var controlMessageType: ControlRequest.Type
      switch controlCommand {
        case .advance:
          controlMessageType = ControlAdvance.self

        case .all:
          controlMessageType = ControlAllInfo.self
          
        case .capture:
          controlMessageType = ControlCapture.self

        case .captureDone:
          controlMessageType = ControlUnknown.self

        case .close:
          controlMessageType = ControlClose.self
          
        case .connect:
          controlMessageType = ControlConnect.self

        case .elapsed:
          controlMessageType = ControlElapsed.self
          
        case .info:
          controlMessageType = ControlInfo.self

        case .open:
          controlMessageType = ControlOpen.self
          
        case .pause:
          controlMessageType = ControlPause.self
          
        case .play:
          controlMessageType = ControlPlay.self
          
        case .ping:
          controlMessageType = ControlPing.self

        case .seek:
          controlMessageType = ControlSeek.self

        case .show:
          controlMessageType = ControlShow.self

        case .state:
          controlMessageType = ControlState.self

        case .unknown:
          controlMessageType = ControlUnknown.self
      }
      
      return try UDPMessageCoder.decode(controlMessageType, from: data)
    } catch {
      return ControlInvalid(command: controlCommand)
    }
  }
}
