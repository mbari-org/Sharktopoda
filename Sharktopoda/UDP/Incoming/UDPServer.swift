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
  
  let connectQueue: DispatchQueue

  var listener: NWListener?
  
  var incomingConnection: UDPIncoming?
  
  static let singleton = UDPServer()
  private init() {
    connectQueue = DispatchQueue(label: "Sharktopoda UDP Connect Queue")
  }
  
  func start() {
    if let _ = listener { stop() }
    
    listener = try! NWListener(using: .udp, on: NWEndpoint.Port(rawValue: UInt16(port!))!)
    
    listener!.stateUpdateHandler = stateUpdate(to:)
    listener!.newConnectionHandler = messageFrom(someConnection:)
    
    listener!.start(queue: connectQueue)
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
  
  private func messageFrom(someConnection: NWConnection) {
    guard incomingConnection == nil else {
      let responseData = ResponseData.failed("Control already connected")
      someConnection.send(content: responseData, completion: .contentProcessed({ _ in }))
      return
    }
    
//    UDPConnect(using: someConnection)
    
    
//    if let connectCommand = udpConnect.connectCommand {
//      self.incomingConnection = UDPIncoming(using: connectCommand)
//      let responseData = ResponseData.ok(IncomingCommand.connect.rawValue)
//      someConnection.send(content: responseData, completion: .contentProcessed({ _ in }))
//    }
  }
  
  func incomingConnection(using connectCommand: ConnectCommand) {
    self.incomingConnection = UDPIncoming(using: connectCommand)
    print("CxInc send ping on new incoming connection for validation")
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
    self.log(hdr: "\(logHdr) (\(port!))", msg)
  }
  
  func log(hdr: String, _ msg: String) {
    NSLog("\(hdr) \(msg)")
  }
}
