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
  // Prefs ensure port is set
  @AppStorage(PrefKeys.port) private var port: Int?
  
  let udpQueue: DispatchQueue
  
  private var listener: NWListener?
  private let logHdr = "Sharktopoda UDP Server"
  
  static let singleton = UDPServer()
  
  private init() {
    udpQueue = DispatchQueue(label: "Sharktopoda UDP Queue")
  }
  
  func start() {
    if let _ = listener { stop() }
    
    listener = try! NWListener(using: .udp, on: NWEndpoint.Port(rawValue: UInt16(port!))!)
    
    listener!.stateUpdateHandler = stateUpdate(to:)
    listener!.newConnectionHandler = accept(connection:)
    
    listener!.start(queue: udpQueue)
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
    listener?.stateUpdateHandler = nil
    listener?.newConnectionHandler = nil
    listener?.cancel()
    
    listener = nil
    
    log("stopped")
  }
  
  func log(_ msg: String) {
    NSLog("\(logHdr) (\(port!)) \(msg)")
  }
}
