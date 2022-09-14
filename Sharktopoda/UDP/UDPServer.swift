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
  private static var portKey = "Sharktopoda.port"
  private static var hdr = "Sharktopoda UDP Server"
  
  private var port: Int = UserDefaults.standard.integer(forKey: UDPServer.portKey)
  
  private var queue: DispatchQueue
  private var listener: NWListener

  init?() {
    queue = DispatchQueue(label: "\(UDPServer.hdr) Queue")
    
    listener = try! NWListener(using: .udp, on: NWEndpoint.Port(rawValue: UInt16(port))!)
    
    listener.stateUpdateHandler = { update in
      let updateHdr = "\(UDPServer.hdr) state update:"
      switch update {
        case .setup, .waiting, .cancelled:
          NSLog("\(updateHdr) \(update)")
        case .ready:
          NSLog("\(updateHdr) is ready: CxInc")
        case .failed(let error):
          NSLog("\(updateHdr) failed with error \(error)")
        @unknown default:
          NSLog("\(updateHdr) unknown")
      }
    }

    listener.newConnectionHandler = { [weak self] connection in
      NSLog("\(connection)")
      
      if let strongSelf = self {
        connection.start(queue: strongSelf.queue)
      }
      
    }
    
    listener.start(queue: queue)
  }
}
