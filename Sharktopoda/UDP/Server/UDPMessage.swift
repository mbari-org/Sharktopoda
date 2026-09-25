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

  // UDP has no close signal, so NWListener treats every distinct (host, port) it
  // sees as a new "connection" and hands us a socket for it that stays open until
  // we cancel it. Clients that open a fresh socket per command (e.g. vcr4j-remote's
  // RVideoIO, used by `vars ml visualize-raw-disconnected`) never send again on that
  // flow, so without this timeout each command leaks one fd until the process runs
  // out (macOS defaults GUI apps to a 256 open-file soft limit).
  static let idleTimeout: TimeInterval = 5

  let connection: NWConnection
  private var idleTimer: DispatchSourceTimer?

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
        scheduleIdleTimeout()
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

      scheduleIdleTimeout()

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

  private func scheduleIdleTimeout() {
    idleTimer?.cancel()
    let timer = DispatchSource.makeTimerSource(queue: UDPMessage.messageQueue)
    timer.schedule(deadline: .now() + UDPMessage.idleTimeout)
    timer.setEventHandler { [weak self] in
      UDP.log(.incoming, "idle for \(UDPMessage.idleTimeout)s, closing connection")
      self?.stop()
    }
    timer.resume()
    idleTimer = timer
  }

  func stop() {
    idleTimer?.cancel()
    idleTimer = nil
    connection.cancel()
    connection.stateUpdateHandler = nil
  }
}
