//
//  UDP.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

class UDP {
  static var server: UDPServer = UDPServer()
  static var client: UDPClient = UDPClient()
  
  static var sharktopodaData: SharktopodaData!
  
  static let singleton = UDP()
  private init() {
  }
  
  static func restartServer() {
    sharktopodaData.udpServer.stop()
    sharktopodaData.udpServer = UDPServer()
  }
  
  static func startClient(using connectCommand: ControlConnect) {
    guard connectCommand.endpoint != client.clientData.endpoint else {
      return
    }
    sharktopodaData.udpClient.stop()
    let udpClient = UDPClient(using: connectCommand)
    DispatchQueue.main.async {
      sharktopodaData.udpClient = udpClient
    }
  }
  
  static func log(hdr: String, _ msg: String) {
    NSLog("\(hdr) \(msg)")
  }
}
