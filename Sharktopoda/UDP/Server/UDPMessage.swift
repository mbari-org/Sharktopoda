//
//  UDPMessage.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network

class UDPMessage {
  static let messageQueue = DispatchQueue(label: "Sharktopoda UDP Message Queue")
  static let captureQueue = DispatchQueue(label: "Sharktopoda UDP Capture Queue")

  typealias ProcessCompletion = (_ response: ControlResponse) -> Void
  
  let connection: NWConnection
  let completion: ProcessCompletion

  static func process(on connection: NWConnection) {
    let _ = UDPMessage(using: connection, completion: { response in
      connection.send(content: response.data(), completion: .contentProcessed({ _ in }))
    })
    connection.start(queue: UDPMessage.messageQueue)
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
        self?.completion(ControlUnknown.failed("empty message"))
        self?.log("empty message")
        return
      }

      let controlMessage = ControlCommand.controlMessage(from: data)
      self?.log("\(controlMessage)")

      let controlResponse = controlMessage.process()
      self?.completion(controlResponse)

      // If frame capture, send a second response re: async frame grab
      if let client = UDP.sharktopodaData.udpClient,
         controlMessage.command == .capture,
         controlResponse.status == .ok,
         let controlCapture = controlMessage as? ControlCapture,
         let controlResponseOk = controlResponse as? ControlResponseCaptureOk {
        let captureTime = controlResponseOk.captureTime

        UDPClient.messageQueue.async {
          Task {
            let captureDoneMessage = await controlCapture.doCapture(captureTime: captureTime)
            client.process(captureDoneMessage)
          }
        }
      } else {
        // CxTBD
//        self?.stop()
      }
    }
  }

  func connectionDidFail(error: Error) {
    let msg = error.localizedDescription
    completion(ControlUnknown.failed(msg))
    log(msg)
    stop()
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
