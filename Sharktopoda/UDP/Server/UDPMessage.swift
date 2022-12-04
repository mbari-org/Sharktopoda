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
  let completion: MessageResult

  private
  init(for connection: NWConnection, completion: @escaping MessageResult) {
    self.connection = connection
    self.completion = completion
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

      // CxTBD guard may not be necessary: Preliminary futzing shows empty data never gets here
      guard let data = data, !data.isEmpty else {
        self?.failed("empty message")
        return
      }

      let controlMessage = ControlCommand.controlMessage(from: data)
      self?.log("\(controlMessage)")

      let responseData = controlMessage.process().data()
      self?.completion(responseData)
    }
  }

  func connectionDidFail(error: Error) {
    let msg = error.localizedDescription
    failed(msg)
    stop()
  }
  
  func failed(_ cause: String) {
    log("Message failed: \(cause)")
    completion(ControlUnknown.failed("empty message").data())
  }

  func stop() {
    connection.cancel()
    connection.stateUpdateHandler = nil
  }
  
  func log(_ msg: String) {
    UDP.log("<- \(msg)")
  }
  
  deinit {
    stop()
  }
}
