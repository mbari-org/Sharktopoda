//
//  UDPIncoming.swift
//  Created for Sharktopoda on 9/18/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network

class UDPClient {
  var connection: NWConnection
  let incomingQueue: DispatchQueue
  
  var controlIsConnected = false
  
  init(using connectCommand: ConnectCommand) {
    let host = NWEndpoint.Host(connectCommand.host)
    let port = NWEndpoint.Port(rawValue: UInt16(connectCommand.port))!
    connection = NWConnection(host: host, port: port, using: .udp)
    incomingQueue = DispatchQueue(label: "Sharktopoda UDP Client Queue")
    
    connection.stateUpdateHandler = self.stateUpdate(to:)
    connection.start(queue: incomingQueue)
    
    let msg = "CxInc handle init udp message".data(using: .utf8)

    connection.send(content: msg, completion: .contentProcessed({ error in
      if let error = error {
        self.log("UDP Connection initialization send error: \(error)")
      }
    }))
  }
  
  func isControl(_ someConnection: NWConnection) -> Bool {
    someConnection.endpoint == connection.endpoint
  }
  
  func stateUpdate(to update: NWConnection.State) {
    switch update {
      case .preparing, .setup, .waiting:
        log("state \(update)")
      case .ready:
        log("ready")
        receiveLoop()
      case .failed(let error):
        log("failed with error \(error)")
        exit(EXIT_FAILURE)
      case .cancelled:
        print("CxInc state updated to cancelled")
      @unknown default:
        log("state unknown")
    }
  }
  
  private func receiveLoop() {
    self.connection.receiveMessage { data, _, isComplete, error in
      if let error = error {
        self.log("receive message error \(error)")
        return
      }
      guard isComplete, let data = data else {
        self.log("receive nil data")
        return
      }
      let msg = String(decoding: data, as: UTF8.self)
      self.log("CxInc handle msg: \(msg)")
      self.receiveLoop()
    }
  }
  
  func stop()  {
    connection.stateUpdateHandler = nil
    connection.cancel()
  }
  
  func log(_ msg: String) {
    let logHdr = "Sharktopoda UDP Incoming Connection"
    UDP.log(hdr: logHdr, msg)
  }
}
