//
//  UDP.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

class UDP {
  static let server: UDPServer = UDPServer.singleton
  static var client: UDPClient?
  

  static let singleton = UDP()
  private init() {
  }
  
  static func start() {
    UDP.server.start()
  }

  static func client(using connectCommand: ControlConnect) {
    if let client = UDP.client {
      client.stop()
      UDP.client = nil
    }
    UDP.client = UDPClient(using: connectCommand)
  }

  static func log(hdr: String, _ msg: String) {
    NSLog("\(hdr) \(msg)")
  }
}
