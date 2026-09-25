//
//  UDPServer.swift
//  Created for Sharktopoda on 9/14/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network
import Darwin

class UDPServer: ObservableObject {
  let queue: DispatchQueue = DispatchQueue(label: "Sharktopoda UDP Server Queue",
                                           qos: .userInteractive)

  var listener: NWListener
  var port: Int

  init(port: Int) {
    self.port = port
    UserDefaults.standard.setValue(port, forKey: PrefKeys.port)

    UDP.sharktopodaData?.udpServerError = nil
    UDPServer.raiseFileDescriptorLimit()

    listener = try! UDP.listener(port: port)
    listener.stateUpdateHandler = stateUpdate(to:)
    listener.newConnectionHandler = UDPMessage.handle(connection:)
    listener.start(queue: queue)
    
    UDP.log(.server, "started on port \(port)")
  }
  
  func runningOnPort() -> Int {
    Int(listener.port?.rawValue ?? 0)
  }
  
  func stateUpdate(to update: NWListener.State) {
    switch update {
      case .setup, .waiting, .ready:
        return
        
      case .cancelled:
        UDP.log(.server, "state \(update)")
        
      case .failed(let error):
        // CxNote This is a bit fragile. 
        let errorLast = "\(error)".split(separator: ":").last
        let errorMsg: String = "\(errorLast ?? "Failed to connect")".trimmingCharacters(in: .whitespaces)
        
        UDP.log(.server, "failed with error \(errorMsg))")
        DispatchQueue.main.async {
          UDP.sharktopodaData.udpServerError = errorMsg
        }
        
      @unknown default:
        UDP.log(.server, "state unknown")
    }
  }
  
  func stop() {
    let port = runningOnPort()

    listener.stateUpdateHandler = nil
    listener.newConnectionHandler = nil
    listener.cancel()

    UDP.log(.server, "stopped on port \(port)")
  }

  // macOS defaults GUI apps to a 256 open-file soft limit, which a burst of
  // rapid-fire UDP commands (e.g. thousands of localizations) can exhaust
  // well before UDPMessage's idle timeout reaps the leftover sockets.
  private static func raiseFileDescriptorLimit() {
    var limit = rlimit()
    guard getrlimit(RLIMIT_NOFILE, &limit) == 0 else { return }
    limit.rlim_cur = min(limit.rlim_max, 4096)
    setrlimit(RLIMIT_NOFILE, &limit)
  }
}
