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
  private static let queue = DispatchQueue(label: "Sharktopoda UDP Server Queue")
  
  // Prefs ensure port is set
  @AppStorage(PrefKeys.port) private var port: Int?
  
  var listener: NWListener?
  
  static let singleton = UDPServer()
  private init() {
  }
  
  func start() {
    if let _ = listener { stop() }
    
    listener = try! NWListener(using: .udp, on: NWEndpoint.Port(rawValue: UInt16(port!))!)
    
    listener!.stateUpdateHandler = stateUpdate(to:)
    listener!.newConnectionHandler = processConnection(from:)

    listener!.start(queue: UDPServer.queue)
  }
  
  func runningOnPort() -> Int {
    Int(listener?.port?.rawValue ?? 0)
  }
  
  func needsRestart() -> Bool {
    port != runningOnPort()
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
    listener?.stateUpdateHandler = nil
    listener?.newConnectionHandler = nil
    listener?.cancel()
    
    listener = nil
    
    log("stopped")
  }
  
  func log(_ msg: String) {
    let logHdr = "Sharktopoda UDP Server"
    UDP.log(hdr: "\(logHdr) (\(port!))", msg)
  }

}
