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
        UDP.log(.incoming, "state update failed error \(error)")
        stop()

      case .cancelled:
        UDP.log(.incoming, "state \(update)")
        return

      @unknown default:
        UDP.log(.incoming, "state unknown")
        return
    }
  }
  
  func processMessage() {
    connection.receiveMessage { [weak self] (data, _, isComplete, error) in
      guard let self = self else { return }

      if let error = error {
        UDP.log(.incoming, "receive failed: \(error.localizedDescription)")
        stop()
        return
      }

      guard isComplete else {
        processMessage()
        return
      }

      guard let data = data, !data.isEmpty else {
        UDP.log(.incoming, "empty message")
        processMessage()
        return
      }

      let controlMessage = UDP.controlMessage(from: data)
      let squelched = UDP.logSquelch.contains(controlMessage.command.rawValue)
      if !squelched {
        UDP.log(.incoming, String(decoding: data, as: UTF8.self))
      }

      let responseData = controlMessage.process().data()
      if !squelched {
        UDP.log(.outgoing, String(decoding: responseData, as: UTF8.self))
      }
      self.connection.send(content: responseData, completion: .contentProcessed({ _ in
        self.processMessage()
      }))
    }
  }
  
  func connectionDidFail(error: Error) {
    let cause = error.localizedDescription
    UDP.log(.incoming, "Message failed: \(cause)")
    stop()
  }
  
  func stop() {
    connection.cancel()
    connection.stateUpdateHandler = nil
  }
}
