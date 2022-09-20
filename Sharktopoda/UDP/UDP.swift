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
  
  let serverQueue: DispatchQueue
  let clientQueue: DispatchQueue
  
  static let singleton = UDP()
  private init() {
    serverQueue = DispatchQueue(label: "Sharktopoda UDP Server Queue")
    clientQueue = DispatchQueue(label: "Sharktopoda UDP Client Queue")
  }
  
  static func start() {
    UDP.server.start(queue: UDP.singleton.serverQueue)
  }

  static func client(using connectCommand: ConnectCommand) {
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
