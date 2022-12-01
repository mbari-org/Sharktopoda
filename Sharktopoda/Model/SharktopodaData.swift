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

  /// Open video windows
  @Published var videoWindows = [String: VideoWindow]()
  
  init() {
    // Needed for notify observing Views of non-View related UDP messaging changes to sharktopodaData
    UDP.sharktopodaData = self
  }
  
  func latestVideoWindow() -> VideoWindow? {
    guard !videoWindows.isEmpty else { return nil }

    let windows: [VideoWindow] = Array(videoWindows.values)

    if let videoWindow = windows.first(where: \.windowData.windowKeyInfo.isKey) {
      return videoWindow
    }

    return windows.sorted(by: { $0.windowData < $1.windowData }).last
  }
}
