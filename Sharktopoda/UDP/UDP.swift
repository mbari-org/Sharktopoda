//
//  UDP.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network

struct UDP {
  private static var defaultServerPort = 8800
  
  static var server: UDPServer = UDPServer(port: UDP.startupServerPort())
  static var client: UDPClient = UDPClient()
  
  static var sharktopodaData: SharktopodaData!
  
  private static func startupServerPort() -> Int {
    var port: Int = UserDefaults.standard.integer(forKey: PrefKeys.port)
    if port == 0 || UInt16.max < port {
      port = UDP.defaultServerPort
      UserDefaults.standard.setValue(port, forKey: PrefKeys.port)
    }
    return port
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
