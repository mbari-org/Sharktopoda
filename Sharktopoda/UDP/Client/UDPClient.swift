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
  
  var isReady = false
  
  init(using connectCommand: ConnectCommand) {
    let host = NWEndpoint.Host(connectCommand.host)
    let port = NWEndpoint.Port(rawValue: UInt16(connectCommand.port))!
    
    connection = NWConnection(host: host, port: port, using: .udp)
    connection.stateUpdateHandler = self.stateUpdate(to:)
    connection.start(queue: UDP.singleton.clientQueue)
  }
  
  func stateUpdate(to update: NWConnection.State) {
    switch update {
      case .preparing, .setup, .waiting:
        log("state \(update)")
      case .ready:
        log("ready")
        isReady = true
        
        let pingRequest = PingRequest().jsonData()
        send(pingRequest)
        
      case .failed(let error):
        log("failed with error \(error)")
        exit(EXIT_FAILURE)
      case .cancelled:
        print("CxInc state updated to cancelled")
      @unknown default:
        log("state unknown")
    }
  }
  
  func send(_ data: Data) {
    if !isReady {
      log("attempted send when connection not ready")
      return
    }
    
    connection.send(content: data, completion: .contentProcessed({ error in
      if let error = error {
        self.log("UDP Client send error: \(error)")
      }
    }))
  }
  
  //  private func receiveLoop() {
  //    self.connection.receiveMessage { data, _, isComplete, error in
  //      if let error = error {
  //        self.log("receive message error \(error)")
  //        return
  //      }
  //      guard isComplete, let data = data else {
  //        self.log("receive nil data")
  //        return
  //      }
  //      let msg = String(decoding: data, as: UTF8.self)
  //      self.log("CxInc handle msg: \(msg)")
  //      self.receiveLoop()
  //    }
  //  }
  
  func stop()  {
    connection.stateUpdateHandler = nil
    connection.cancel()
  }
  
  func log(_ msg: String) {
    let logHdr = "Sharktopoda UDP Incoming Connection"
    UDP.log(hdr: logHdr, msg)
  }
}
