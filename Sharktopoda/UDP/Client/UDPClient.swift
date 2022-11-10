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
  
  typealias UDPClientConnectCompletion = (UDPClient) -> Void
  typealias UDPClientMessageCompletion = (Data?) -> Void
  
  private static let queue = DispatchQueue(label: "Sharktopoda UDP Client Queue")
  
  var connection: NWConnection?
  
  var clientData: ClientData
  var connectCompletion: UDPClientConnectCompletion?
  var timeout: TimeInterval
  
  static func clientTimeout() -> TimeInterval {
    let prefSetting: Int = UserDefaults.standard.integer(forKey: PrefKeys.timeout)
    let prefMillis = prefSetting == 0 ? 1000 : prefSetting
    return TimeInterval(prefMillis) / 1000.0
  }
  
  static func connect(using connectCommand: ControlConnect, completion: @escaping UDPClientConnectCompletion) {
    
    let udpClient = UDPClient(using: connectCommand)
    udpClient.connectCompletion = completion
    udpClient.connection?.start(queue: UDPClient.queue)
  }
  
  init() {
    clientData = ClientData(host: "", port: 0)
    timeout = UDPClient.clientTimeout()
  }
  
  private init(using connectCommand: ControlConnect) {
    let host = connectCommand.host
    let port = connectCommand.port
    clientData = ClientData(host: host, port: port)
    
    timeout = UDPClient.clientTimeout()
    
    connection = UDP.connection(host: host, port: port)
    connection?.stateUpdateHandler = stateUpdate(to:)
    
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
    process(ClientPing()) { [weak self] data in
      if let data = data {
        self?.log("CxInc Inspect ping response: \(String(decoding: data, as: UTF8.self))")
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
      self.log("\(message.command) not processed. No client connection.")
      return
    }
    
    let data = message.data()
    var receivedReply = false
    
    
    UDPClient.queue.asyncAfter(deadline: .now() + timeout) {
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
    clientData = ClientData(host: host, port: port, active: active)
    
    let activeState = (clientData.active ? "" : "in") + "active"
    log("\(clientData.endpoint) \(activeState)")
  }
  
  func udpError(message: String) {
    let host = clientData.host
    let port = clientData.port
    clientData = ClientData(host: host, port: port, error: message)
  }
  
  func udpError(error: Error) {
    udpError(message: error.localizedDescription)
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
    UDP.log("-> \(msg)")
  }
}
