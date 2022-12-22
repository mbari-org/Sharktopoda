//
//  SharktopodaData.swift
//  Created for Sharktopoda on 9/13/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit
import SwiftUI

final class SharktopodaData: ObservableObject {
  @Published var udpServer: UDPServer = UDP.server
  @Published var udpServerError: String? = nil
  @Published var udpClient: UDPClient?
  
  var videoWindows = [String: VideoWindow]()
  var openVideos = OpenedVideos()
  
  var mainViewWindow: NSWindow?
  
  init() {
    // Needed for notify observing Views of non-View related UDP messaging changes to sharktopodaData
    UDP.sharktopodaData = self
  }
}


// MARK: Misc
extension SharktopodaData {
  static func normalizedId() -> String {
    normalizedId(UUID().uuidString)
  }
  
  static func normalizedId(_ id: String) -> String {
    id.lowercased()
  }
  
  func videoInfos() -> [VideoInfo] {
    videoWindows.values.map {
      VideoInfo(using: $0)
    }
  }
  
  func window(for uuid: String) -> VideoWindow? {
    let id = SharktopodaData.normalizedId(uuid)
    return videoWindows[id]
  }
}
