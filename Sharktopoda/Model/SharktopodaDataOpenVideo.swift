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
  func openingVideo(id: String) async {
    await openVideos.opening(id: id)
  }
  
  func openVideoState(id: String) async -> SharktopodaData.OpenVideoState {
    await openVideos.state(id: id)
  }
  
  func windowOpened(videoWindow: VideoWindow) async {
    let id = await videoWindow.windowData.id
    await openVideos.opened(id: id)
    videoWindows[id] = videoWindow
  }
  
  func releaseVideo(id: String) async {
    await openVideos.close(id: id)
    
    guard let videoWindow = videoWindows[id] else { return }
    
    await videoWindow.windowData.player.replaceCurrentItem(with: nil)
    await videoWindows.removeValue(forKey: videoWindow.id)
  }
}

