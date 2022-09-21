//
//  ControlCommand.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

enum ControlCommand: String, Codable {
  case allInfo
  case capture
  case close
  case connect
  case elapsedTime
  case frameAdvance
  case info
//  case localizationsAdd = "add localizations"
  case open
  case pause
  case ping
  case play
  case playback
  case seek
  case show
  case unknown
  
  struct ControlMessageCommand: Decodable {
    var command: String
  }
  
  static func controlMessage(from data: Data) -> ControlMessage {
    let json = JSONDecoder()

    // Ensure control command is valid
    var controlCommand: ControlCommand
    do {
      // Ensure message has command field
      let controlMessageCommand = try json.decode(ControlMessageCommand.self, from: data)

      // Ensure command is known
      let rawCommand = controlMessageCommand.command
      guard let maybeControlCommand = ControlCommand(rawValue: rawCommand) else {
        return ControlUnknown(command: .unknown, cause: "unknown command: \(rawCommand)")
      }
      controlCommand = maybeControlCommand
    }
    catch {
      return ControlInvalid()
    }
    
    do {
      var controlMessageType: ControlMessage.Type
      switch controlCommand {
        case .close:
          controlMessageType = ControlClose.self
          
        case .connect:
          controlMessageType = ControlConnect.self
          
        case .frameAdvance:
          controlMessageType = ControlFrameAdvance.self
          
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
      
      return try json.decode(controlMessageType, from: data)
    } catch {
      return ControlInvalid(command: controlCommand)
    }
  }
}
