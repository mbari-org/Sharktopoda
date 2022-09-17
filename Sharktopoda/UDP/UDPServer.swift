//
//  UDPServer.swift
//  Created for Sharktopoda on 9/14/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network
import SwiftUI

class UDPServer {
  private let logHdr = "Sharktopoda UDP Server"

  private var listener: NWListener
  private let udpQueue: DispatchQueue
  
  init(port: UInt16, queue: DispatchQueue) {
    self.udpQueue = queue

    listener = try! NWListener(using: .udp, on: NWEndpoint.Port(rawValue: port)!)
    
    listener.stateUpdateHandler = stateUpdate(to:)
    listener.newConnectionHandler = accept(connection:)
    
    listener.start(queue: queue)
  }

  func stateUpdate(to update: NWListener.State) {
    switch update {
      case .setup, .waiting, .cancelled:
        log("state \(update)")
      case .ready:
        log("ready")
      case .failed(let error):
        log("failed with error \(error)")
        exit(EXIT_FAILURE)
      @unknown default:
        log("state unknown")
    }
  }
  
  private func accept(connection: NWConnection) {
    log("connection")
    connection.start(queue: self.udpQueue)
  }
  
  func stop() {
    listener.stateUpdateHandler = nil
    listener.newConnectionHandler = nil
    listener.cancel()
    
    let port = String(describing: listener.port?.rawValue)
    
    log("stopped on port \(port)")
  }
  
  func log(_ msg: String) {
    NSLog("\(logHdr) \(msg)")
  }
}
