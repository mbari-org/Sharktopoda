//
//  UDPServer.swift
//  Created for Sharktopoda on 9/14/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network

class UDPServer: ObservableObject {
  let queue: DispatchQueue = DispatchQueue(label: "Sharktopoda UDP Server Queue",
                                           qos: .userInteractive)

  var listener: NWListener
  var port: Int
  
  init(port: Int) {
    self.port = port
    UserDefaults.standard.setValue(port, forKey: PrefKeys.port)
    
    UDP.sharktopodaData?.udpServerError = nil
    
    listener = try! UDP.listener(port: port)
    listener.stateUpdateHandler = stateUpdate(to:)
    listener.newConnectionHandler = UDPMessage.handle(connection:)
    listener.start(queue: queue)
    
    log("started on port \(port)")
  }
  
  func runningOnPort() -> Int {
    Int(listener.port?.rawValue ?? 0)
  }
  
  func stateUpdate(to update: NWListener.State) {
    switch update {
      case .setup, .waiting, .ready:
        return
        
      case .cancelled:
        log("state \(update)")
        
      case .failed(let error):
        // CxNote This is a bit fragile. 
        let errorLast = "\(error)".split(separator: ":").last
        let errorMsg: String = "\(errorLast ?? "Failed to connect")".trimmingCharacters(in: .whitespaces)
        
        log("failed with error \(errorMsg))")
        DispatchQueue.main.async {
          UDP.sharktopodaData.udpServerError = errorMsg
        }
        
      @unknown default:
        log("state unknown")
    }
  }
  
  func stop() {
    let port = runningOnPort()
    
    listener.stateUpdateHandler = nil
    listener.newConnectionHandler = nil
    listener.cancel()
    
    log("stopped on port \(port)")
  }
  
  func log(_ msg: String) {
    UDP.log("Server \(msg)")
  }
  
}
