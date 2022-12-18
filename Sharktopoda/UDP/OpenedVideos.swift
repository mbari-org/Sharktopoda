//
//  OpenedVideos.swift
//  Created for Sharktopoda on 12/6/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Network

/// Concurrency processing for async opening of video windows
actor OpenedVideos {
  private var openedVideos = [String: SharktopodaData.OpenVideoState]()

  func opening(id: String) {
    openedVideos[id] = .loading
  }
  
  func opened(id: String) {
    openedVideos[id] = .loaded
  }
  
  func state(id: String) -> SharktopodaData.OpenVideoState {
    if let openedState = openedVideos[id] {
      return openedState
    }
    return .notOpen
  }

  func close(id: String) {
    openedVideos.removeValue(forKey: id)
  }
}
