//
//  UDPServer.swift
//  Created for Sharktopoda on 9/14/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Darwin

class UDPServer: ObservableObject {
  private let queue = DispatchQueue(label: "Sharktopoda UDP Server Queue",
                                    qos: .userInitiated)

  private var socketFD: Int32 = -1
  private var readSource: DispatchSourceRead?

  var port: Int

  init(port: Int) {
    self.port = port
    UserDefaults.standard.setValue(port, forKey: PrefKeys.port)

    UDP.sharktopodaData?.udpServerError = nil

    guard let port16 = UInt16(exactly: port), port16 > 0 else {
      reportError("Invalid port \(port)")
      return
    }

    guard bind(port: port16) else { return }

    var rcvBuf = 4 * 1024 * 1024
    setsockopt(socketFD, SOL_SOCKET, SO_RCVBUF, &rcvBuf, socklen_t(MemoryLayout<Int>.size))

    let source = DispatchSource.makeReadSource(fileDescriptor: socketFD, queue: queue)
    source.setEventHandler { [weak self] in
      self?.receiveDatagrams()
    }
    source.setCancelHandler { [socketFD] in
      close(socketFD)
    }
    source.resume()
    readSource = source

    UDP.log(.server, "started on port \(port)")
  }

  deinit {
    stop()
  }

  private func bind(port: UInt16) -> Bool {
    var fd = socket(AF_INET6, SOCK_DGRAM, IPPROTO_UDP)
    if fd >= 0 {
      var v6Only: Int32 = 0
      setsockopt(fd, IPPROTO_IPV6, IPV6_V6ONLY, &v6Only, socklen_t(MemoryLayout<Int32>.size))

      var addr = sockaddr_in6()
      addr.sin6_len = UInt8(MemoryLayout<sockaddr_in6>.size)
      addr.sin6_family = sa_family_t(AF_INET6)
      addr.sin6_port = port.bigEndian
      addr.sin6_addr = in6addr_any
      let bound = withUnsafePointer(to: &addr) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
          Darwin.bind(fd, $0, socklen_t(MemoryLayout<sockaddr_in6>.size))
        }
      }
      if bound == 0 {
        socketFD = fd
        return true
      }
      close(fd)
    }

    fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
    guard fd >= 0 else {
      reportError("Failed to create socket: \(String(cString: strerror(errno)))")
      return false
    }

    var addr = sockaddr_in()
    addr.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    addr.sin_family = sa_family_t(AF_INET)
    addr.sin_port = port.bigEndian
    addr.sin_addr = in_addr(s_addr: INADDR_ANY)
    let bound = withUnsafePointer(to: &addr) {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
        Darwin.bind(fd, $0, socklen_t(MemoryLayout<sockaddr_in>.size))
      }
    }
    guard bound == 0 else {
      let error = String(cString: strerror(errno))
      close(fd)
      reportError("Failed to bind port \(port): \(error)")
      return false
    }

    socketFD = fd
    return true
  }

  // Protocol caps messages at 4096 bytes
  private static let maxMessageSize = 4096

  private func receiveDatagrams() {
    var buffer = [UInt8](repeating: 0, count: UDPServer.maxMessageSize + 1)
    var sender = sockaddr_storage()

    while true {
      var senderLen = socklen_t(MemoryLayout<sockaddr_storage>.size)
      let count = withUnsafeMutablePointer(to: &sender) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
          recvfrom(socketFD, &buffer, buffer.count, MSG_DONTWAIT, $0, &senderLen)
        }
      }

      if count < 0 {
        if errno != EAGAIN && errno != EWOULDBLOCK {
          UDP.log(.incoming, "receive failed: \(String(cString: strerror(errno)))")
        }
        return
      }

      if count == 0 {
        UDP.log(.incoming, "empty message")
        continue
      }

      if count > UDPServer.maxMessageSize {
        UDP.log(.incoming, "oversize message (> \(UDPServer.maxMessageSize) bytes)")
        let responseData = ControlUnknown("message exceeds \(UDPServer.maxMessageSize) bytes")
          .process().data()
        UDP.log(.outgoing, String(decoding: responseData, as: UTF8.self))
        send(responseData, to: sender, senderLen: senderLen)
        continue
      }

      let data = Data(buffer[0..<count])
      let controlMessage = UDP.controlMessage(from: data)
      let squelched = UDP.logSquelch.contains(controlMessage.command.rawValue)
      if !squelched {
        UDP.log(.incoming, String(decoding: data, as: UTF8.self))
      }

      let responseData = controlMessage.process().data()
      if !squelched {
        UDP.log(.outgoing, String(decoding: responseData, as: UTF8.self))
      }

      send(responseData, to: sender, senderLen: senderLen)
    }
  }

  private func send(_ responseData: Data, to sender: sockaddr_storage, senderLen: socklen_t) {
    responseData.withUnsafeBytes { response in
      guard let responseBytes = response.baseAddress else { return }
      var sender = sender
      let sent = withUnsafePointer(to: &sender) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
          sendto(socketFD, responseBytes, responseData.count, 0, $0, senderLen)
        }
      }
      if sent < 0 {
        UDP.log(.outgoing, "send failed: \(String(cString: strerror(errno)))")
      }
    }
  }

  private func reportError(_ message: String) {
    UDP.log(.server, message)
    DispatchQueue.main.async {
      UDP.sharktopodaData?.udpServerError = message
    }
  }

  func stop() {
    readSource?.cancel()
    readSource = nil

    UDP.log(.server, "stopped on port \(port)")
  }
}
