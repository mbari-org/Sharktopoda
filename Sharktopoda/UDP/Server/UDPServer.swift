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
  
  var listener: NWListener?
  var udpConnect: UDPConnect?
  
  static let singleton = UDPServer()
  private init() {
  }
  
  func start(queue: DispatchQueue) {
    if let _ = listener { stop() }
    
    listener = try! NWListener(using: .udp, on: NWEndpoint.Port(rawValue: UInt16(port!))!)
    
    listener!.stateUpdateHandler = stateUpdate(to:)
    listener!.newConnectionHandler = messageFrom(incomingConnection:)
    
    listener!.start(queue: queue)
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
  
  private func messageFrom(incomingConnection: NWConnection) {
    if let udpConnect = self.udpConnect {
      udpConnect.stop()
    }
    udpConnect = UDPConnect(using: incomingConnection)

    let responseData = ResponseData.ok(IncomingCommand.connect.rawValue)
    incomingConnection.send(content: responseData, completion: .contentProcessed({ _ in }))
  }
  
  func connectClient(using connectCommand: ConnectCommand) {
    if let udpConnect = self.udpConnect {
      udpConnect.stop()
    }
    self.udpConnect = nil

    UDP.client(using: connectCommand)
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
