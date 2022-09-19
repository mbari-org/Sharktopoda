//
//  UDPConnect.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network

class UDPConnect {
  var connection: NWConnection
  
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
      let commandData = CommandData(data)
      if let error = commandData.error {
        let responseData = ResponseData.failed(response: "unknown", cause: error)
        connection.send(content: responseData, completion: .contentProcessed({ _ in }))
        return
      }
//      switch commandData.command {
//        case IncomingCommand.ping:
//          let responseData = ResponseData.ping()
//          connection.send(content: responseData, completion: .contentProcessed({ _ in }))
//        default:
//          let responseData = ResponseData.failed(response: commandData.command, cause: "Invalid command")
//          connection.send(content: responseData, completion: .contentProcessed({ _ in }))
//      }
      print("Command: \(commandData.command)")
    }
  }
  
  func connectionDidFail(error: Error) {
    log("Failed error: \(error)")
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
