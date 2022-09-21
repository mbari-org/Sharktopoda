//
//  UDPMessage.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network

class UDPMessage {
  private static let queue = DispatchQueue(label: "Sharktopoda UDP Message Queue")
  
  typealias ResponseCompletion = (_ response: Data) -> Void
  
  let connection: NWConnection
  let completion: ResponseCompletion
  
  init(using connection: NWConnection, completion: @escaping ResponseCompletion) {
    self.connection = connection
    self.completion = completion
    
    connection.stateUpdateHandler = self.stateUpdate(to:)
  }
  
  func start() {
    connection.start(queue: UDPMessage.queue)
  }
  
  func stateUpdate(to update: NWConnection.State) {
    switch update {
      case .preparing, .setup, .waiting:
        return

      case .ready:
        self.log("state \(update)")
        processMessage()

      case .failed(let error):
        print(error)
        log("state update failed error \(error)")
        exit(EXIT_FAILURE)

      case .cancelled:
        log("state \(update)")
        return

      @unknown default:
        log("state unknown")
        return
    }
  }
  
  func processMessage() {
    connection.receiveMessage { [self] (data, _, isComplete, error) in
      guard isComplete else {
        return
      }
      
      // CxTBD guard may not be necessary: Preliminary futzing shows empty data never gets here
      guard let data = data, !data.isEmpty else {
        completion(ControlResponse.failed(.unknown, cause: "empty message"))
        self.log("empty message")
        return
      }
      
      completion(ControlCommand.controlMessage(from: data).process())
    }
  }

  func connectionDidFail(error: Error) {
    let msg = "Failed error: \(error)"
    completion(ControlResponse.failed(.unknown, cause: msg))
    log(msg)
    stop()
  }
  
  func stop() {
    if connection.stateUpdateHandler != nil {
      self.connection.stateUpdateHandler = nil
      connection.cancel()
    }
  }
  
  func log(_ msg: String) {
    let logHdr = "Sharktopoda UDP Connect"
    UDP.log(hdr: logHdr, msg)
  }
  
  deinit {
    stop()
  }
}
