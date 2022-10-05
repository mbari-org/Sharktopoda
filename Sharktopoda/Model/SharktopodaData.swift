//
//  SharktopodaData.swift
//  Created for Sharktopoda on 9/13/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import AppKit

final class SharktopodaData: ObservableObject {
  @Published var udpServer: UDPServer = UDP.server
  @Published var udpClient: UDPClient = UDP.client
  
  @Published var udpServerError: String? = nil

  @Published var videoWindows = [String: VideoWindow]()

  init() {
    // This allows non-View related changes to sharktopoda data to notify observing Views
    UDP.sharktopodaData = self
  }
  
  func latedVideoWindow() -> VideoWindow? {
    guard !videoWindows.isEmpty else { return nil }
     
    let windows: [VideoWindow] = Array(videoWindows.values)
    
    if let videoWindow = windows.first(where: { $0.keyInfo.isKey }) {
      return videoWindow
    }
    return windows.sorted(by: { $0 < $1 }).last
  }
}
