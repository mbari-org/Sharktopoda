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
}

// MARK: Convenience
extension UDP {
  static func connect(_ clientData: UDPClientData) -> NWConnection {
    NWConnection(to: UDP.endpoint(clientData.host, clientData.port), using: .udp)
  }

  static func endpoint(_ host: String, _ port: Int) -> NWEndpoint {
    NWEndpoint.hostPort(host: NWEndpoint.Host(host), port: UDP.port(port))
  }
  
  static func listener(port: Int) throws -> NWListener {
    try NWListener(using: .udp, on: UDP.port(port))
  }
  
  static func port(_ port: Int) -> NWEndpoint.Port {
    NWEndpoint.Port(integerLiteral: NWEndpoint.Port.IntegerLiteralType(port))
  }
}

extension UDP {
  static func controlMessage(from data: Data) -> ControlMessage {
    // Ensure control command is valid
    var controlCommand: ControlCommand
    do {
      // Parse command from message
      let messageCommand = try UDPMessageCoder.decode(MessageCommand.self, from: data).command
      
      // Ensure valid command
      guard let validCommand = ControlCommand(rawValue: messageCommand) else {
        return ControlUnknown("unknown command: \(messageCommand)")
      }
      controlCommand = validCommand
    }
    catch let error {
      UDP.log("state update failed error \(error)")
      return ControlInvalid(cause: error.localizedDescription)
    }
    
    do {
      var messageType: ControlMessage.Type
      switch controlCommand {
        case .addLocalizations:
          messageType = ControlAddLocalizations.self
          
        case .advance:
          messageType = ControlAdvance.self
          
        case .all:
          messageType = ControlAllInfo.self
          
        case .capture:
          messageType = ControlCapture.self
          
        case .clearLocalizations:
          messageType = ControlClearLocalizations.self
          
        case .close:
          messageType = ControlClose.self
          
        case .connect:
          messageType = ControlConnect.self
          
        case .elapsed:
          messageType = ControlElapsed.self
          
        case .info:
          messageType = ControlInfo.self
          
        case .open:
          messageType = ControlOpen.self
          
        case .pause:
          messageType = ControlPause.self
          
        case .play:
          messageType = ControlPlay.self
          
        case .ping:
          messageType = ControlPing.self
          
        case .removeLocalizations:
          messageType = ControlRemoveLocalizations.self
          
        case .seek:
          messageType = ControlSeek.self
          
        case .selectLocalizations:
          messageType = ControlSelectLocalizations.self
          
        case .show:
          messageType = ControlShow.self
          
        case .state:
          messageType = ControlState.self
          
        case .unknown:
          messageType = ControlUnknown.self
          
        case .updateLocalizations:
          messageType = ControlUpdateLocalizations.self
      }
      return try UDPMessageCoder.decode(messageType, from: data)
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
