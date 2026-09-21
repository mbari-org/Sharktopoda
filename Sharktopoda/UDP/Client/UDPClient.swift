//
//  UDPIncoming.swift
//  Created for Sharktopoda on 9/18/22.
//
//  Apache License 2.0 — See project LICENSE file
//
import Foundation
import Network

class UDPClient: ObservableObject {
  typealias UDPClientConnectCompletion = (UDPClient) -> Void
  typealias UDPClientMessageCompletion = (Data?) -> Void
  
  static let messageQueue = DispatchQueue(label: "Sharktopoda UDP Client Queue")
  private static let timeoutQueue = DispatchQueue(label: "Sharktopoda UDP Timeout Queue")
  
  var connection: NWConnection?
  
  var clientData: UDPClientData
  var connectCompletion: UDPClientConnectCompletion?
  var timeout: TimeInterval
  
  static func clientTimeout() -> TimeInterval {
    let prefSetting: Int = UserDefaults.standard.integer(forKey: PrefKeys.timeout)
    let prefMillis = prefSetting == 0 ? 1000 : prefSetting
    return TimeInterval(prefMillis) / 1000.0
  }
  
  static func connect(using controlConnect: ControlConnect, completion: @escaping UDPClientConnectCompletion) {
    let host = controlConnect.host
    let port = controlConnect.port
    let clientData = UDPClientData(host: host, port: port)

    if let client = UDP.sharktopodaData.udpClient {
      if clientData.endpoint == client.clientData.endpoint {
        client.udpActive(false)
        client.pingConnection()
        return
      } else if client.clientData.active {
        client.stop()
      }
    }
    
    /// CxSmell This has an odor and needs to be tidied up
    let _ = UDPClient(using: clientData, completion: completion)
  }
  
  private init(using clientData: UDPClientData, completion: @escaping UDPClientConnectCompletion) {

    self.clientData = clientData
    timeout = UDPClient.clientTimeout()
    connectCompletion = completion

    connection = UDP.connect(clientData)
    connection?.stateUpdateHandler = stateUpdate(to:)
    connection?.start(queue: UDPClient.messageQueue)

    UDP.log(.outgoing, "connecting to \(clientData.endpoint)")
  }
  
  func stateUpdate(to update: NWConnection.State) {
    switch update {
      case .preparing, .setup, .waiting:
        return

      case .ready:
        pingConnection()

      case .failed(let error):
        udpError(error: error)
        UDP.log(.outgoing, "failed with error \(error)")
        connectCompletion?(self)

      case .cancelled:
        udpActive(false)
        UDP.log(.outgoing, "state \(update)")
        connectCompletion?(self)

      @unknown default:
        UDP.log(.outgoing, "unknown state \(update)")
    }
  }
  
  func pingConnection() {
    process(ClientMessagePing()) { [weak self] data in
      if data != nil {
        self?.udpActive(true)
      }
      self?.connectCompletion?(self!)
    }
  }
  
  func process(_ message: ClientMessage) {
    process(message, completion: completionOk(message.command))
  }
  
  func process(_ message: ClientMessage, completion: @escaping UDPClientMessageCompletion) {
    guard let connection = connection else {
      UDP.log(.outgoing, "\(message.command) not processed. No client connection.")
      return
    }
    
    let data = message.data()
    let squelched = UDP.logSquelch.contains(message.command.rawValue)
    if !squelched {
      UDP.log(.outgoing, String(decoding: data, as: UTF8.self))
    }
    var receivedReply = false
    
    UDPClient.timeoutQueue.asyncAfter(deadline: .now() + timeout) {
      guard receivedReply == false else { return }
      completion(nil)
    }
    
    connection.send(content: data, completion: .contentProcessed({ _ in }))
    connection.receiveMessage(completion: { [weak self] data, _, isComplete, error in
      receivedReply = true
      if let error = error {
        self?.udpError(error: error)
        UDP.log(.outgoing, "\(message.command) error: \(error)")
      } else {
        if !squelched, let data = data {
          UDP.log(.incoming, String(decoding: data, as: UTF8.self))
        }
        completion(data)
      }
    })
  }
  
  private func completionOk(_ command: ClientCommand) -> UDPClientMessageCompletion {
    return { data in
      if data == nil {
        UDP.log(.outgoing, "No response to \(command)")
      }
    }
  }
  
  func send(_ message: ClientMessage, completion: NWConnection.SendCompletion) {
    guard clientData.active else {
      UDP.log(.outgoing, "client connection not active ")
      return
    }
    
    let data = message.data()
    if !UDP.logSquelch.contains(message.command.rawValue) {
      UDP.log(.outgoing, String(decoding: data, as: UTF8.self))
    }
    connection?.send(content: data, completion: completion)
  }
  
//  func receive() {
//
//  }
    
  func udpActive(_ active: Bool) {
    let host = clientData.host
    let port = clientData.port
    clientData = UDPClientData(host: host, port: port, active: active)
    
    let activeState = (clientData.active ? "" : "in") + "active"
    UDP.log(.outgoing, "\(clientData.endpoint) \(activeState)")
  }
  
  func udpError(message: String) {
    let host = clientData.host
    let port = clientData.port
    clientData = UDPClientData(host: host, port: port, error: message)
  }
  
  func udpError(error: Error) {
    udpError(message: error.localizedDescription)
  }
  
  func stop()  {
    if let connection = connection {
      connection.stateUpdateHandler = nil
      connection.cancel()
      
      let endpoint = clientData.endpoint
      clientData = UDPClientData(host: "", port: 0)
      
      UDP.log(.outgoing, "stopped \(endpoint)")
    }
  }
}
