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
  @AppStorage(PrefKeys.port) private var prefPort: Int = 8800
  
  var listener: NWListener?
  
  static let singleton = UDPServer()
  private init() {
  }
  
  private static let queue = DispatchQueue(label: "Sharktopoda UDP Server Queue")
  
  func start() {
    if let _ = listener {
      guard prefPort != runningOnPort() else {
        return
      }
      stop()
    }
    
    listener = try! NWListener(using: .udp, on: NWEndpoint.Port(rawValue: UInt16(prefPort))!)
    listener!.stateUpdateHandler = stateUpdate(to:)
    listener!.newConnectionHandler = processConnection(from:)
    
    listener!.start(queue: UDPServer.queue)
    
    log("started on port \(prefPort)")
  }
  
  func runningOnPort() -> Int {
    Int(listener?.port?.rawValue ?? 0)
  }
  
  func stateUpdate(to update: NWListener.State) {
    switch update {
      case .setup, .waiting:
        return
        
      case .ready, .cancelled:
        log("state \(update)")
        
      case .failed(let error):
        log("failed with error \(error)")
        exit(EXIT_FAILURE)
        
      @unknown default:
        log("state unknown")
    }
  }
  
  private func processConnection(from connection: NWConnection) {
    let udpMessage = UDPMessage(using: connection) { data in
      connection.send(content: data, completion: .contentProcessed({ _ in }))
    }
    udpMessage.start()
  }
  
  func stop() {
    let port = runningOnPort()
    
    listener?.stateUpdateHandler = nil
    listener?.newConnectionHandler = nil
    listener?.cancel()
    
    listener = nil
    
    log("stopped on port \(port)")
  }
  
  func log(_ msg: String) {
    let logHdr = "Sharktopoda UDP Server"
    UDP.log(hdr: "\(logHdr)", msg)
  }
  
}
