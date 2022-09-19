//
//  UDPOutgoing.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network

class UDPOutgoing {
  let connection: NWConnection
  let outgoingQueue: DispatchQueue

  init(host sHost: String, port iPort: Int) {
    outgoingQueue = DispatchQueue(label: "Sharktopoda UDP Outgoing Queue")
    
    let host = NWEndpoint.Host(sHost)
    let port = NWEndpoint.Port(rawValue: UInt16(iPort))!
    connection = NWConnection(host: host, port: port, using: .udp)
  }

  convenience init(port: Int) {
    self.init(host: "localhost", port: port)
  }
  
//  func start
}
