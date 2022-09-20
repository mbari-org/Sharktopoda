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

  var connectCommand: ControlConnect?
  
  init(using udpConnection: NWConnection) {
    connection = udpConnection
    connection.stateUpdateHandler = self.stateUpdate(to:)
    connection.start(queue: UDP.singleton.serverQueue)
  }
  
  func stateUpdate(to update: NWConnection.State) {
    switch update {
      case .preparing, .setup, .waiting:
        return
      case .ready:
        log("state \(update)")
        processMessage(self.connection)
      case .failed(let error):
        log("state update failed error \(error)")
        exit(EXIT_FAILURE)
      case .cancelled:
        log("state \(update)")
      @unknown default:
        log("state unknown")
    }
  }
  
  func processMessage(_ connection: NWConnection) {
    connection.receiveMessage { [self] (data, _, isComplete, error) in
      guard isComplete else {
        self.log("message not complete")
        return
      }
      guard let data = data, !data.isEmpty else {
        self.log("empty message")
        return
      }
      let commandData = ControlCommandData(from: data)
      self.log(commandData.command.rawValue)
      if let error = commandData.error {
        let responseData = ControlResponse.failed(.unknown, cause: error)
        connection.send(content: responseData, completion: .contentProcessed({ _ in }))
        return
      }
      switch commandData.command {
        case .connect:
          processConnect(using: commandData.data, on: connection)
          
        case .ping:
          let responseData = ControlResponse.ping()
          connection.send(content: responseData, completion: .contentProcessed({ _ in }))
          
        default:
          let responseData = ControlResponse.failed(commandData.command, cause: "Not connected")
          connection.send(content: responseData, completion: .contentProcessed({ _ in }))
      }
    }
  }
  
  func processConnect(using data: Data, on connection: NWConnection) {
    do {
      let connectCommand = try ControlConnect(from: data)
      UDP.server.connectClient(using: connectCommand)
    }
    catch {
      let responseData = ControlResponse.failed(.connect, cause: "Invalid JSON data")
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
    UDP.log(hdr: logHdr, msg)
  }
}
