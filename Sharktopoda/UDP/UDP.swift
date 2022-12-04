//
//  UDP.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network

struct UDP {
  private static var defaultServerPort = 8800
  
  static var server: UDPServer = UDPServer(port: UDP.startupServerPort())
  
  static var sharktopodaData: SharktopodaData!
  
  private static func startupServerPort() -> Int {
    var port: Int = UserDefaults.standard.integer(forKey: PrefKeys.port)
    if port == 0 || UInt16.max < port {
      port = UDP.defaultServerPort
      UserDefaults.standard.setValue(port, forKey: PrefKeys.port)
    }
    return port
  }

  static func listener(port: Int) throws -> NWListener {
    try NWListener(using: .udp, on: UDP.port(port))
  }
  
  static func connection(host: String, port: Int) -> NWConnection {
    NWConnection(to: UDP.endpoint(host, port), using: .udp)
  }

  static func port(_ port: Int) -> NWEndpoint.Port {
    NWEndpoint.Port(integerLiteral: NWEndpoint.Port.IntegerLiteralType(port))
  }
  
  static func endpoint(_ host: String, _ port: Int) -> NWEndpoint {
    NWEndpoint.hostPort(host: NWEndpoint.Host(host), port: UDP.port(port))
  }
  
  static func controlMessage(from data: Data) -> ControlMessage {
    // Ensure control command is valid
    var controlCommand: ControlCommand
    do {
      // Ensure message has command field
      let controlMessageCommand = try UDPMessageCoder.decode(MessageCommand.self, from: data)
      
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
  

  
  static func log(_ msg: String) {
    #if DEBUG
    NSLog("UDP \(msg)")
    #endif
  }
}
