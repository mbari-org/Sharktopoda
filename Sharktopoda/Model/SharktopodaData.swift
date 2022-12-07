//
//  SharktopodaData.swift
//  Created for Sharktopoda on 9/13/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import AppKit
import SwiftUI

final class SharktopodaData: ObservableObject {
  @Published var udpServer: UDPServer = UDP.server
  @Published var udpServerError: String? = nil
  @Published var udpClient: UDPClient?
  
  private var videoWindows = [String: VideoWindow]()
  private var openVideos = OpenedVideos()
  
  init() {
    // Needed for notify observing Views of non-View related UDP messaging changes to sharktopodaData
    UDP.sharktopodaData = self
  }
}

// MARK: Concurrency Control for Open Video
extension SharktopodaData {
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
  
  func closeVideo(id: String) async {
    await openVideos.close(id: id)
    
    guard let videoWindow = videoWindows[id] else { return }
    await videoWindow.windowData.player.replaceCurrentItem(with: nil)
    await videoWindows.removeValue(forKey: videoWindow.id)
  }
}

// MARK: Misc
extension SharktopodaData {
  func videoInfos() -> [VideoInfo] {
    videoWindows.values.map {
      VideoInfo(using: $0)
    }
  }
  
  func window(for id: String) -> VideoWindow? {
    videoWindows[id]
  }
}

// MARK: Latest Video Window
/// Based on KeyInfo time
extension SharktopodaData {
  func latestVideoWindow() -> VideoWindow? {
    guard !videoWindows.isEmpty else { return nil }
    
    let windows: [VideoWindow] = Array(videoWindows.values)
    
    if let videoWindow = windows.first(where: \.windowData.windowKeyInfo.isKey) {
      return videoWindow
    }
    
    return windows.sorted(by: { $0.windowData < $1.windowData }).last
  }
}

// MARK: Open Video State
extension SharktopodaData {
  enum OpenVideoState {
    case loading
    case loaded
    case notOpen
  }
}
