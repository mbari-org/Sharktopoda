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
  @Published var udpClient: UDPClient?
  @Published var udpServerError: String? = nil

  @Published var videoAssets = [String: VideoAsset]()
  @Published var videoViews = [String: VideoView]()

  @Published var videoWindows = [String: VideoWindow]()

  init() {
    // This allows non-View related changes to sharktopoda data to notify observing Views
    UDP.sharktopodaData = self
  }
  
  func latestVideoView() -> VideoView? {
    guard !videoViews.isEmpty else { return nil }

    let views = Array(videoViews.values)
    if let videoView = views.first(where: \.keyInfo.isKey) {
      return videoView
    }

    return views.sorted(by: { $0 < $1 }).last
  }

  // CxInc
//  func latestVideoWindow() -> VideoWindow? {
//    guard !videoWindows.isEmpty else { return nil }
//
//    let windows: [VideoWindow] = Array(videoWindows.values)
//
//    if let videoWindow = windows.first(where: \.keyInfo.isKey) {
//      return videoWindow
//    }
//
//    return windows.sorted(by: { $0 < $1 }).last
//  }
}
