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
  
  @Published var videoWindows = [String: VideoWindow]()
  
  // This allows non-View access to sharktopoda data to update observing Views
  init() {
    UDP.sharktopodaData = self
  }
  
  
  
}
