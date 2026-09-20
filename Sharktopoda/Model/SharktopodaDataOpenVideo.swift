//
//  SharktopodaDataOpenVideo.swift
//  Created for Sharktopoda on 12/22/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit
import SwiftUI

extension SharktopodaData {
  // MARK: Open Video State
  enum OpenVideoState {
    case loading
    case loaded
    case notOpen
  }
  
  var hasOpenVideos: Bool {
    !videoWindows.isEmpty
  }

  // MARK: Concurrency Control for Open Video
  func windowOpened(videoWindow: VideoWindow) {
    let id = videoWindow.id
    videoWindows[id] = videoWindow

    let pending = openVideos.opened(id: id)
    pending.forEach { $0(videoWindow) }
  }
  
  func releaseVideo(id: String) {
    openVideos.close(id: id)
  }
}
