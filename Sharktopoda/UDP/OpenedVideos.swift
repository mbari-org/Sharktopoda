//
//  OpenedVideos.swift
//  Created for Sharktopoda on 12/6/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

/// Concurrency processing for async opening of video windows
final class OpenedVideos {
  private let lock = NSLock()
  private var openedVideos = [String: SharktopodaData.OpenVideoState]()
  private var pendingCommands = [String: [(VideoWindow) -> Void]]()

  func beginOpening(id: String) -> SharktopodaData.OpenVideoState {
    lock.lock()
    defer { lock.unlock() }

    let previous = openedVideos[id] ?? .notOpen
    if previous == .notOpen {
      openedVideos[id] = .loading
    }
    return previous
  }

  func opened(id: String) -> [(VideoWindow) -> Void] {
    lock.lock()
    defer { lock.unlock() }

    openedVideos[id] = .loaded
    return pendingCommands.removeValue(forKey: id) ?? []
  }

  func state(id: String) -> SharktopodaData.OpenVideoState {
    lock.lock()
    defer { lock.unlock() }

    return openedVideos[id] ?? .notOpen
  }

  func enqueueIfLoading(id: String, command: @escaping (VideoWindow) -> Void) -> Bool {
    lock.lock()
    defer { lock.unlock() }

    guard openedVideos[id] == .loading else { return false }
    pendingCommands[id, default: []].append(command)
    return true
  }

  func close(id: String) {
    lock.lock()
    let dropped = pendingCommands.removeValue(forKey: id) ?? []
    openedVideos.removeValue(forKey: id)
    lock.unlock()

    if !dropped.isEmpty {
      UDP.log("Dropping \(dropped.count) queued command(s) for \(id); video did not open")
    }
  }
}
