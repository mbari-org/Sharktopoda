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

  static var heartbeatInterval: TimeInterval = 5

  var connection: NWConnection?

  var clientData: UDPClientData
  var connectCompletion: UDPClientConnectCompletion?
  var timeout: TimeInterval

  private var heartbeatTimer: DispatchSourceTimer?

  private var requestQueue: [(message: ClientMessage, completion: UDPClientMessageCompletion)] = []
  private var inFlight: (token: Int, completion: UDPClientMessageCompletion)?
  private var requestToken = 0

  static func clientTimeout() -> TimeInterval {
    let prefSetting: Int = UserDefaults.standard.integer(forKey: PrefKeys.timeout)
    let prefMillis = prefSetting == 0 ? 1000 : prefSetting
    return TimeInterval(prefMillis) / 1000.0
  }

  static func connect(using controlConnect: ControlConnect, completion: @escaping UDPClientConnectCompletion) {
    let host = controlConnect.host
    let port = controlConnect.port

    guard (1...Int(UInt16.max)).contains(port) else {
      UDP.log(.outgoing, "invalid client port \(port)")
      return
    }

    let clientData = UDPClientData(host: host, port: port)

    if let client = UDP.sharktopodaData.udpClient {
      if clientData.endpoint == client.clientData.endpoint {
        client.udpActive(false)
        client.pingConnection()
        return
      } else {
        client.stop()
      }
    }

    /// CxSmell This has an odor and needs to be tidied up
    let _ = UDPClient(using: clientData, completion: completion)
  }

  init(using clientData: UDPClientData,
       timeout: TimeInterval = UDPClient.clientTimeout(),
       enableHeartbeat: Bool = true,
       completion: UDPClientConnectCompletion? = nil) {

    self.clientData = clientData
    self.timeout = timeout
    connectCompletion = completion

    connection = UDP.connect(clientData)
    connection?.stateUpdateHandler = stateUpdate(to:)
    connection?.start(queue: UDPClient.messageQueue)

    if enableHeartbeat {
      startHeartbeat()
    }

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

  private func startHeartbeat() {
    let timer = DispatchSource.makeTimerSource(queue: UDPClient.messageQueue)
    timer.schedule(deadline: .now() + UDPClient.heartbeatInterval,
                   repeating: UDPClient.heartbeatInterval)
    timer.setEventHandler { [weak self] in
      self?.heartbeat()
    }
    timer.resume()
    heartbeatTimer = timer
  }

  /// Ping the remote app so its departure (or return) flips the active state
  private func heartbeat() {
    guard inFlight == nil, requestQueue.isEmpty else { return }
    enqueue(ClientMessagePing()) { _ in }
  }

  func pingConnection() {
    process(ClientMessagePing()) { [weak self] data in
      guard let self else { return }
      if data != nil {
        udpActive(true)
      }
      connectCompletion?(self)
    }
  }

  func process(_ message: ClientMessage) {
    process(message, completion: completionOk(message.command))
  }

  func process(_ message: ClientMessage, completion: @escaping UDPClientMessageCompletion) {
    UDPClient.messageQueue.async { [weak self] in
      self?.enqueue(message, completion: completion)
    }
  }

  private func enqueue(_ message: ClientMessage, completion: @escaping UDPClientMessageCompletion) {
    requestQueue.append((message, completion))
    sendNextRequest()
  }

  private func sendNextRequest() {
    guard inFlight == nil, !requestQueue.isEmpty else { return }
    let (message, completion) = requestQueue.removeFirst()

    guard let connection = connection else {
      UDP.log(.outgoing, "\(message.command) not processed. No client connection.")
      completion(nil)
      sendNextRequest()
      return
    }

    let data = message.data()
    let squelched = UDP.logSquelch.contains(message.command.rawValue)
    if !squelched {
      UDP.log(.outgoing, String(decoding: data, as: UTF8.self))
    }

    requestToken += 1
    let token = requestToken
    inFlight = (token, completion)

    connection.send(content: data, completion: .contentProcessed({ _ in }))
    connection.receiveMessage(completion: { [weak self] data, _, _, error in
      self?.receiveResponse(data: data, error: error, token: token, squelched: squelched)
    })

    UDPClient.timeoutQueue.asyncAfter(deadline: .now() + timeout) { [weak self] in
      self?.timeoutRequest(token: token)
    }
  }

  private func receiveResponse(data: Data?, error: NWError?, token: Int, squelched: Bool) {
    /// Stale receive from a superseded connection; nothing waiting on it
    guard let inFlight, inFlight.token == token else { return }
    self.inFlight = nil

    if let error = error {
      udpError(error: error)
      UDP.log(.outgoing, "response error: \(error)")
      inFlight.completion(nil)
      noteReachable(false)
    } else {
      if !squelched, let data = data {
        UDP.log(.incoming, String(decoding: data, as: UTF8.self))
      }
      inFlight.completion(data)
      noteReachable(data != nil)
    }

    sendNextRequest()
  }

  private func timeoutRequest(token: Int) {
    UDPClient.messageQueue.async { [weak self] in
      guard let self, self.inFlight?.token == token else { return }
      let completion = self.inFlight!.completion
      self.inFlight = nil
      completion(nil)
      self.noteReachable(false)

      /// A timed-out request leaves a stale receive armed on the connection;
      /// rebuild so it can never consume a later response
      self.rebuildConnection()
      self.sendNextRequest()
    }
  }

  private func rebuildConnection() {
    connection?.stateUpdateHandler = nil
    connection?.cancel()

    let connection = UDP.connect(clientData)
    self.connection = connection
    connection.stateUpdateHandler = { [weak self] state in
      if case .failed(let error) = state {
        self?.udpError(error: error)
      }
    }
    connection.start(queue: UDPClient.messageQueue)
  }

  private func noteReachable(_ reachable: Bool) {
    guard reachable != clientData.active else { return }
    udpActive(reachable)
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

  func udpActive(_ active: Bool) {
    let host = clientData.host
    let port = clientData.port
    clientData = UDPClientData(host: host, port: port, active: active)

    let activeState = (clientData.active ? "" : "in") + "active"
    UDP.log(.outgoing, "\(clientData.endpoint) \(activeState)")

    publishClientData()
  }

  private func publishClientData() {
    DispatchQueue.main.async {
      UDP.sharktopodaData.objectWillChange.send()
    }
  }

  func udpError(message: String) {
    let host = clientData.host
    let port = clientData.port
    clientData = UDPClientData(host: host, port: port, error: message)
  }

  func udpError(error: Error) {
    udpError(message: error.localizedDescription)
  }

  func stop() {
    heartbeatTimer?.cancel()
    heartbeatTimer = nil

    if let connection = connection {
      connection.stateUpdateHandler = nil
      connection.cancel()
      self.connection = nil

      let endpoint = clientData.endpoint
      clientData = UDPClientData(host: "", port: 0)

      UDP.log(.outgoing, "stopped \(endpoint)")
    }

    UDPClient.messageQueue.async { [weak self] in
      guard let self else { return }
      let pending = self.requestQueue
      self.requestQueue.removeAll()
      let inFlight = self.inFlight
      self.inFlight = nil
      inFlight?.completion(nil)
      pending.forEach { $0.completion(nil) }
    }
  }

  deinit {
    heartbeatTimer?.cancel()
  }
}
