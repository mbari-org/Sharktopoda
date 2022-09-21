//
//  UDPMessage.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network

class UDPMessage {
  let connection: NWConnection
  
  init(using connection: NWConnection) {
    self.connection = connection
    connection.stateUpdateHandler = self.stateUpdate(to:)
    connection.start(queue: UDP.singleton.serverQueue)
  }
  
  static func processMessage(on connection: NWConnection) {
    let udpMessage = UDPMessage(using: connection)
    
  }
  
  func stateUpdate(to update: NWConnection.State) {
    switch update {
      case .preparing, .setup, .waiting:
        return
      case .ready:
        self.log("state \(update)")
        processMessage(self.connection)
      case .failed(let error):
        print(error)
        log("state update failed error \(error)")
        exit(EXIT_FAILURE)
      case .cancelled:
        log("state \(update)")
        return
      @unknown default:
        log("state unknown")
        return
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
      let controlMessage = ControlMessageData(from: data)
      self.log(controlMessage.command.rawValue)
      if let error = controlMessage.error {
        respond(ControlResponse.failed(.unknown, cause: error))
        return
      }
      do {
        switch controlMessage.command {
          case .connect:
            let connectResponse = try ControlConnect.process(data: data)
            respond(connectResponse)
            
          case .ping:
            respond(ControlResponse.ping())
            
          default:
            respond(ControlResponse.failed(controlMessage.command, cause: "Not connected"))
        }
      }
      catch {
        respond(ControlResponse.failed(.connect, cause: "Invalid message"))
      }
    }
  }
  
  func respond(_ data: Data) {
    connection.send(content: data, completion: .contentProcessed({ _ in }))
    stop()
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
