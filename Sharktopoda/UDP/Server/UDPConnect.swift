//
//  UDPConnect.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network

class UDPConnect {
  let connection: NWConnection

  var connectCommand: ConnectCommand?
  
  init(using udpConnection: NWConnection) {
    connection = udpConnection
    connection.stateUpdateHandler = self.stateUpdate(to:)
    connection.start(queue: UDPServer.singleton.connectQueue)
  }
  
  func stateUpdate(to update: NWConnection.State) {
    switch update {
      case .preparing, .setup, .waiting:
        log("state \(update)")
      case .ready:
        log("ready")
        processMessage(self.connection)
      case .failed(let error):
        log("state update failed error \(error)")
        exit(EXIT_FAILURE)
      case .cancelled:
        print("state updated to cancelled")
      @unknown default:
        log("state unknown")
    }
  }
  
  func processMessage(_ connection: NWConnection) {
    connection.receiveMessage { [self] (data, _, isComplete, error) in
      guard isComplete else {
        self.log("receive not complete")
        return
      }
      guard let data = data, !data.isEmpty else {
        self.log("receive empty message")
        return
      }
      let commandData = CommandData(from: data)
      if let error = commandData.error {
        let responseData = ResponseData.failed("unknown", cause: error)
        connection.send(content: responseData, completion: .contentProcessed({ _ in }))
        return
      }
      switch commandData.command {
        case IncomingCommand.connect.rawValue:
          processConnect(using: commandData.data, on: connection)
          
        case IncomingCommand.ping.rawValue:
          let responseData = ResponseData.ping()
          connection.send(content: responseData, completion: .contentProcessed({ _ in }))
          
        default:
          let responseData = ResponseData.failed(commandData.command, cause: "Not connected")
          connection.send(content: responseData, completion: .contentProcessed({ _ in }))
      }
    }
  }
  
  func processConnect(using data: Data, on connection: NWConnection) {
    do {
      self.connectCommand = try ConnectCommand(from: data)
      
    }
    catch let error {
      let responseData = ResponseData.failed(IncomingCommand.connect.rawValue, cause: "\(error)")
      connection.send(content: responseData, completion: .contentProcessed({ _ in }))
    }
  }
  
  func connectionDidFail(error: Error) {
    log("Failed error: \(error)")
    stop()
  }
  
  func stop() {
    if connection.stateUpdateHandler != nil {
      self.connection.stateUpdateHandler = nil
      connection.cancel()
    }
  }
  
  func log(_ msg: String) {
    let logHdr = "Sharktopoda UDP Connect"
    UDPServer.singleton.log(hdr: logHdr, msg)
  }
}
