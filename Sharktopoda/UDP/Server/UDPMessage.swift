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
  
  typealias ProcessCompletion = (_ response: ControlResponse) -> Void
  
  let connection: NWConnection
  let completion: ProcessCompletion

  static func process(on connection: NWConnection) {
    let _ = UDPMessage(using: connection, completion: { response in
        
      connection.send(content: response.data(), completion: .contentProcessed({ _ in }))
    })
    connection.start(queue: UDPMessage.queue)
  }

  private
  init(using connection: NWConnection, completion: @escaping ProcessCompletion) {
    self.connection = connection
    self.completion = completion
    connection.stateUpdateHandler = self.stateUpdate(to:)
  }
  
  func stateUpdate(to update: NWConnection.State) {
    switch update {
      case .preparing, .setup, .waiting:
        return

      case .ready:
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
    connection.receiveMessage { [weak self] (data, _, isComplete, error) in
      guard isComplete else {
        return
      }
      
      // CxTBD guard may not be necessary: Preliminary futzing shows empty data never gets here
      guard let data = data, !data.isEmpty else {
        self?.completion(ControlResponseCommand.failed(.unknown, cause: "empty message"))
        self?.log("empty message")
        return
      }

      let controlMessage = ControlCommand.controlMessage(from: data)
      self?.log("\(controlMessage)")
      self?.completion(controlMessage.process())
    }
  }

  func connectionDidFail(error: Error) {
    let msg = error.localizedDescription
    completion(ControlResponseCommand.failed(.unknown, cause: msg))
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
    UDP.log("<- \(msg)")
  }
  
  deinit {
    stop()
  }
}
