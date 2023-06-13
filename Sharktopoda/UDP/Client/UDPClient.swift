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

    log("connecting to \(clientData.endpoint)")
  }
  
  func stateUpdate(to update: NWConnection.State) {
    switch update {
      case .preparing, .setup, .waiting:
        return

      case .ready:
        pingConnection()

      case .failed(let error):
        udpError(error: error)
        log("failed with error \(error)")
        connectCompletion?(self)

      case .cancelled:
        udpActive(false)
        log("state \(update)")
        connectCompletion?(self)

      @unknown default:
        log("unknown state \(update)")
    }
  }
  
  func pingConnection() {
    process(ClientMessagePing()) { [weak self] data in
      if data != nil {
        self?.log("Received ping")
        self?.udpActive(true)
      } else {
        self?.log("Missing ping")
      }
      
      self?.connectCompletion?(self!)
    }
  }
  
  func process(_ message: ClientMessage) {
    process(message, completion: completionOk(message.command))
  }
  
  func process(_ message: ClientMessage, completion: @escaping UDPClientMessageCompletion) {
    guard let connection = connection else {
      self.log("\(message.command) not processed. No client connection.")
      return
    }
    
    let data = message.data()
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
        self?.log("\(message) error: \(error)")
      } else {
        completion(data)
      }
    })
  }
  
  private func completionOk(_ command: ClientCommand) -> UDPClientMessageCompletion {
    return { [weak self] data in
      guard let data = data else {
        self?.log("No response to \(command)")
        return
      }
//      let response = String(decoding: data, as: UTF8.self?)
      self?.log("command \(command) got response: \(data)")
    }
  }
  
  func send(_ message: ClientMessage, completion: NWConnection.SendCompletion) {
    guard clientData.active else {
      log("client connection not active ")
      return
    }
    
    log("send \(message.command)")
    
    let data = message.data()
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
    log("\(clientData.endpoint) \(activeState)")
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
      
      log("stopped \(endpoint)")
    }
  }
  
  func log(_ msg: String) {
    UDP.log("-> \(msg)")
  }
}
