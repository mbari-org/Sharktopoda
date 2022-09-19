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
  
  var udpConnect: UDPConnect?
//  var controlConnection: UDPIncoming?
//  var controlConnection: UDPIncoming?
  
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
      udpConnect = UDPConnect(using: someConnection)
    
//    if let connection = controlConnection {
//      if connection.isControl(someConnection) {
//        print("CxInc Process message from controlEndpoint")
//      } else {
//        print("CxInc Ignore message from !controlEndpoint")
//      }
//    } else {
//      print("CxInc Process first message to establish controlEndpoint")
//      controlConnection = UDPIncoming(using: someConnection)
//    }
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
