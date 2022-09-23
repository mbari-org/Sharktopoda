//
//  UDPIncoming.swift
//  Created for Sharktopoda on 9/18/22.
//
//  Apache License 2.0 — See project LICENSE file
//
import Foundation
import Network

class UDPClient: ObservableObject {
  struct ClientData {
    let host: String
    let port: Int
    var active: Bool = false
    var error: String? = nil
    
    var endpoint: String {
      "\(host):\(port)"
    }
  }

  private static let queue = DispatchQueue(label: "Sharktopoda UDP Client Queue")
  
  var connection: NWConnection?

  var clientData: ClientData
  
  init() {
    clientData = ClientData(host: "", port: 0)
  }

  init(using connectCommand: ControlConnect) {
    let host = connectCommand.host
    let port = connectCommand.port
    clientData = ClientData(host: host, port: port)

    let endpointHost = NWEndpoint.Host(host)
    let endpointPort = NWEndpoint.Port(rawValue: UInt16(port))!
    let endpoint = NWEndpoint.hostPort(host: endpointHost, port: endpointPort)
    
    let connection = NWConnection(to: endpoint, using: .udp)
    connection.stateUpdateHandler = self.stateUpdate(to:)
    connection.start(queue: UDPClient.queue)

    self.connection = connection
    
    log("connecting to \(clientData.endpoint)")

  }

  func stateUpdate(to update: NWConnection.State) {
    switch update {
      case .preparing, .setup, .waiting:
        return
      case .ready:
        log("state \(update)")
        ping()
      case .failed(let error):
        udpError(error: error)
        log("failed with error \(error)")
        exit(EXIT_FAILURE)
      case .cancelled:
        udpActive(active: false)
        log("state \(update)")
      @unknown default:
        log("state unknown")
    }
  }
  
  func ping() {
    log("ping \(clientData.endpoint)")
    
    let data = ClientPing().jsonData()
    connection?.send(content: data, completion: .contentProcessed({ [weak self] error in
      if let error = error {
        self?.udpError(error: error)
        self?.log("ping error: \(error)")
      } else {
        self?.udpActive(active: true)
      }
    }))
  }
  
  func send(_ message: ClientMessage, completion: NWConnection.SendCompletion) {
    guard clientData.active else {
      log("client connection not active ")
      return
    }
    
    log("send \(message.command)")
    
    let data = message.jsonData()
    connection?.send(content: data, completion: completion)
  }

  func udpActive(active: Bool) {
    let host = clientData.host
    let port = clientData.port
    clientData = ClientData(host: host, port: port, active: active)
  
    let activeState = (clientData.active ? "" : "in") + "active"
    log("\(clientData.endpoint) \(activeState)")
  }

  func udpError(error: Error) {
    let host = clientData.host
    let port = clientData.port
    clientData = ClientData(host: host, port: port, error: error.localizedDescription)
  }
  
  func stop()  {
    if let connection = connection {
      connection.stateUpdateHandler = nil
      connection.cancel()
      
      let endpoint = clientData.endpoint
      clientData = ClientData(host: "", port: 0)

      log("stopped \(endpoint)")
    }
  }
  
  func log(_ msg: String) {
    let logHdr = "Sharktopoda UDP Client"
    UDP.log(hdr: logHdr, msg)
  }
}
