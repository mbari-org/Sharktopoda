//
//  UDP.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network

class UDP {
  static var server: UDPServer = UDPServer()
  static var client: UDPClient = UDPClient()
  
  static var sharktopodaData: SharktopodaData!
  
  static let singleton = UDP()
  private init() {
  }

  static func listener(port: Int) throws -> NWListener {
    try NWListener(using: .udp, on: UDP.port(port))
  }
  
  static func connection(host: String, port: Int) -> NWConnection {
    NWConnection(to: UDP.endpoint(host, port), using: .udp)
  }

  static func port(_ port: Int) -> NWEndpoint.Port {
    NWEndpoint.Port(integerLiteral: NWEndpoint.Port.IntegerLiteralType(port))
  }
  
  static func endpoint(_ host: String, _ port: Int) -> NWEndpoint {
    NWEndpoint.hostPort(host: NWEndpoint.Host(host), port: UDP.port(port))
  }
  
  static func log(_ msg: String) {
    NSLog("UDP \(msg)")
  }
}
