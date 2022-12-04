//
//  UDPMessage.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network

class UDPMessage {
  typealias MessageResult = (_ result: Data) -> Void

  static let messageQueue = DispatchQueue(label: "Sharktopoda UDP Message Queue",
                                          qos: .userInitiated)

  let connection: NWConnection

  private
  init(for connection: NWConnection, completion: @escaping MessageResult) {
    self.connection = connection
    connection.stateUpdateHandler = stateUpdate(to:)
  }
  
  static func handle(connection: NWConnection) {
    let handler = UDPMessage(for: connection) { data in
      connection.send(content: data, completion: .contentProcessed({ _ in }))
    }
    connection.stateUpdateHandler = handler.stateUpdate(to:)
    connection.start(queue: UDPMessage.messageQueue)
  }
  
  func stateUpdate(to update: NWConnection.State) {
    switch update {
      case .preparing, .setup, .waiting:
        return

      case .ready:
        processMessage()

      case .failed(let error):
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
      
      guard let self = self else { return }

      // CxTBD guard may not be necessary: Preliminary futzing shows empty data never gets here
      guard let data = data, !data.isEmpty else {
        self.log("empty message")
        return
      }

      let controlMessage = UDP.controlMessage(from: data)
      self.log("\(controlMessage)")

      let responseData = controlMessage.process().data()
      self.connection.send(content: responseData, completion: .contentProcessed({ _ in
        self.stop()
      }))
    }
  }

  func connectionDidFail(error: Error) {
    let cause = error.localizedDescription
    log("Message failed: \(cause)")
    stop()
  }

  func stop() {
    connection.cancel()
    connection.stateUpdateHandler = nil
  }
  
  func log(_ msg: String) {
    UDP.log("<- \(msg)")
  }
}
