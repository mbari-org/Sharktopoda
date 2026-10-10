//
//  UDPClientTests.swift
//  Created for Sharktopoda.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network
import XCTest
@testable import Sharktopoda

final class UDPClientTests: XCTestCase {

  private var sharktopodaData: SharktopodaData!
  private var peer: TestUDPPeer!
  private var client: UDPClient?
  private var savedHeartbeatInterval: TimeInterval = UDPClient.heartbeatInterval

  override func setUpWithError() throws {
    try super.setUpWithError()
    savedHeartbeatInterval = UDPClient.heartbeatInterval
    sharktopodaData = SharktopodaData()
    peer = TestUDPPeer()
    try peer.start()
  }

  override func tearDownWithError() throws {
    client?.stop()
    client = nil
    peer.stop()
    peer = nil
    UDPClient.heartbeatInterval = savedHeartbeatInterval
    sharktopodaData = nil
    try super.tearDownWithError()
  }

  func testConnectPingMarksActive() {
    let connected = expectation(description: "connected")
    client = makeClient(timeout: 0.5, enableHeartbeat: false) { client in
      XCTAssertTrue(client.clientData.active)
      connected.fulfill()
    }
    wait(for: [connected], timeout: 2)
    XCTAssertTrue(client?.clientData.active == true)
  }

  func testSerializesOutboundRequests() {
    let connected = expectation(description: "connected")
    client = makeClient(timeout: 1.0, enableHeartbeat: false) { _ in
      connected.fulfill()
    }
    wait(for: [connected], timeout: 2)

    peer.autoReply = false
    peer.resetReceived()

    let firstDone = expectation(description: "first response")
    let secondDone = expectation(description: "second response")

    client?.process(ClientMessageOpenDone(uuid: "video-a")) { data in
      XCTAssertNotNil(data)
      firstDone.fulfill()
    }
    client?.process(ClientMessageOpenDone(uuid: "video-b")) { data in
      XCTAssertNotNil(data)
      secondDone.fulfill()
    }

    let firstArrived = expectation(description: "first request arrived alone")
    waitForPeerReceivedCount(1, fulfillment: firstArrived)
    wait(for: [firstArrived], timeout: 2)

    let firstBatch = peer.snapshotReceived()
    XCTAssertEqual(firstBatch.count, 1, "second request must wait until the first is answered")
    let firstPayload = String(decoding: firstBatch[0], as: UTF8.self)
    XCTAssertTrue(firstPayload.contains("video-a"))

    peer.replyToOldest()

    let secondArrived = expectation(description: "second request arrived")
    waitForPeerReceivedCount(2, fulfillment: secondArrived)
    wait(for: [firstDone, secondArrived], timeout: 2)

    let secondBatch = peer.snapshotReceived()
    XCTAssertEqual(secondBatch.count, 2)
    let secondPayload = String(decoding: secondBatch[1], as: UTF8.self)
    XCTAssertTrue(secondPayload.contains("video-b"))

    peer.replyToOldest()
    wait(for: [secondDone], timeout: 2)
  }

  func testTimeoutMarksInactiveAndCompletesNil() {
    let connected = expectation(description: "connected")
    client = makeClient(timeout: 0.2, enableHeartbeat: false) { _ in
      connected.fulfill()
    }
    wait(for: [connected], timeout: 2)
    XCTAssertTrue(client?.clientData.active == true)

    peer.autoReply = false
    peer.dropIncoming = true

    let timedOut = expectation(description: "request timed out")
    client?.process(ClientMessageOpenDone(uuid: "gone")) { data in
      XCTAssertNil(data)
      timedOut.fulfill()
    }
    wait(for: [timedOut], timeout: 2)

    XCTAssertFalse(client?.clientData.active == true)
  }

  func testHeartbeatRecoversActiveWhenRemoteReturns() {
    UDPClient.heartbeatInterval = 0.2

    let connected = expectation(description: "connected")
    client = makeClient(timeout: 0.15, enableHeartbeat: true) { _ in
      connected.fulfill()
    }
    wait(for: [connected], timeout: 2)
    XCTAssertTrue(client?.clientData.active == true)

    peer.autoReply = false
    peer.dropIncoming = true

    let becameInactive = expectation(description: "heartbeat marked inactive")
    waitUntil(timeout: 3, fulfillment: becameInactive) {
      self.client?.clientData.active == false
    }
    wait(for: [becameInactive], timeout: 3)

    peer.dropIncoming = false
    peer.autoReply = true

    let becameActive = expectation(description: "heartbeat marked active again")
    waitUntil(timeout: 3, fulfillment: becameActive) {
      self.client?.clientData.active == true
    }
    wait(for: [becameActive], timeout: 3)
  }

  func testStopFailsPendingCompletions() {
    let connected = expectation(description: "connected")
    client = makeClient(timeout: 2.0, enableHeartbeat: false) { _ in
      connected.fulfill()
    }
    wait(for: [connected], timeout: 2)

    peer.autoReply = false

    let pending = expectation(description: "pending completion")
    client?.process(ClientMessageOpenDone(uuid: "pending")) { data in
      XCTAssertNil(data)
      pending.fulfill()
    }

    let firstArrived = expectation(description: "request left client")
    waitForPeerReceivedCount(1, fulfillment: firstArrived)
    wait(for: [firstArrived], timeout: 2)

    client?.stop()
    wait(for: [pending], timeout: 2)
  }

  // MARK: - Helpers

  private func makeClient(timeout: TimeInterval,
                          enableHeartbeat: Bool,
                          completion: @escaping UDPClient.UDPClientConnectCompletion) -> UDPClient {
    let data = UDPClientData(host: "127.0.0.1", port: Int(peer.port))
    return UDPClient(using: data,
                     timeout: timeout,
                     enableHeartbeat: enableHeartbeat,
                     completion: completion)
  }

  private func waitForPeerReceivedCount(_ count: Int, fulfillment: XCTestExpectation) {
    waitUntil(timeout: 2, fulfillment: fulfillment) {
      self.peer.receivedCount >= count
    }
  }

  private func waitUntil(timeout: TimeInterval,
                         fulfillment: XCTestExpectation,
                         poll: @escaping () -> Bool) {
    let deadline = Date().addingTimeInterval(timeout)
    func tick() {
      if poll() {
        fulfillment.fulfill()
      } else if Date() < deadline {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02, execute: tick)
      }
    }
    tick()
  }
}

// MARK: - Loopback remote app

private final class TestUDPPeer {
  private var listener: NWListener?
  private let queue = DispatchQueue(label: "Sharktopoda.TestUDPPeer")
  private(set) var port: UInt16 = 0
  private var receivedMessages: [Data] = []

  var autoReply = true
  var dropIncoming = false

  private var pendingReplies: [NWConnection] = []
  private let lock = NSLock()

  var receivedCount: Int {
    lock.lock()
    defer { lock.unlock() }
    return receivedMessages.count
  }

  func snapshotReceived() -> [Data] {
    lock.lock()
    defer { lock.unlock() }
    return receivedMessages
  }

  func start() throws {
    let listener = try NWListener(using: .udp, on: .any)
    self.listener = listener

    let ready = DispatchSemaphore(value: 0)
    var readyError: Error?

    listener.stateUpdateHandler = { [weak self] state in
      switch state {
        case .ready:
          self?.port = listener.port?.rawValue ?? 0
          ready.signal()
        case .failed(let error):
          readyError = error
          ready.signal()
        default:
          break
      }
    }

    listener.newConnectionHandler = { [weak self] connection in
      self?.accept(connection)
    }

    listener.start(queue: queue)

    let result = ready.wait(timeout: .now() + 2)
    if result == .timedOut {
      throw NSError(domain: "TestUDPPeer", code: 1, userInfo: [
        NSLocalizedDescriptionKey: "listener did not become ready"
      ])
    }
    if let readyError {
      throw readyError
    }
    guard port != 0 else {
      throw NSError(domain: "TestUDPPeer", code: 2, userInfo: [
        NSLocalizedDescriptionKey: "listener port unavailable"
      ])
    }
  }

  func stop() {
    lock.lock()
    pendingReplies.forEach { $0.cancel() }
    pendingReplies.removeAll()
    receivedMessages.removeAll()
    lock.unlock()
    listener?.cancel()
    listener = nil
  }

  func resetReceived() {
    lock.lock()
    receivedMessages.removeAll()
    pendingReplies.removeAll()
    lock.unlock()
  }

  func replyToOldest() {
    lock.lock()
    let connection = pendingReplies.isEmpty ? nil : pendingReplies.removeFirst()
    lock.unlock()
    guard let connection else { return }
    sendOk(on: connection)
  }

  private func accept(_ connection: NWConnection) {
    connection.start(queue: queue)
    receive(on: connection)
  }

  private func receive(on connection: NWConnection) {
    connection.receiveMessage { [weak self] data, _, _, _ in
      guard let self else { return }
      guard let data, !data.isEmpty else { return }

      self.lock.lock()
      if self.dropIncoming {
        self.lock.unlock()
        return
      }
      self.receivedMessages.append(data)
      let shouldAutoReply = self.autoReply
      if !shouldAutoReply {
        self.pendingReplies.append(connection)
      }
      self.lock.unlock()

      if shouldAutoReply {
        self.sendOk(on: connection)
      }
    }
  }

  private func sendOk(on connection: NWConnection) {
    let reply = Data(#"{"response":"ping","status":"ok"}"#.utf8)
    connection.send(content: reply, completion: .contentProcessed { _ in
      connection.cancel()
    })
  }
}
