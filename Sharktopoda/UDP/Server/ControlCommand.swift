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
  
  struct ControlMessageCommand: Decodable {
    var command: String
  }
  
  static func controlMessage(from data: Data) -> ControlMessage {
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
    catch let error {
      UDP.log("state update failed error \(error)")
      return ControlInvalid(cause: error.localizedDescription)
    }
    
    do {
      var controlMessageType: ControlMessage.Type
      switch controlCommand {
        case .addLocalizations:
          controlMessageType = ControlAddLocalizations.self
          
        case .advance:
          controlMessageType = ControlAdvance.self

        case .all:
          controlMessageType = ControlAllInfo.self
          
        case .capture:
          controlMessageType = ControlCapture.self

        case .clearLocalizations:
          controlMessageType = ControlClearLocalizations.self
          
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

        case .removeLocalizations:
          controlMessageType = ControlRemoveLocalizations.self

        case .seek:
          controlMessageType = ControlSeek.self

        case .selectLocalizations:
          controlMessageType = ControlSelectLocalizations.self
          
        case .show:
          controlMessageType = ControlShow.self

        case .state:
          controlMessageType = ControlState.self

        case .unknown:
          controlMessageType = ControlUnknown.self
          
        case .updateLocalizations:
          controlMessageType = ControlUpdateLocalizations.self
      }
      
      return try UDPMessageCoder.decode(controlMessageType, from: data)
    } catch let error {
      return ControlInvalid(command: controlCommand, cause: error.localizedDescription)
    }
  }
}
