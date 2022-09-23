//
//  SharktopodaData.swift
//  Created for Sharktopoda on 9/13/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

final class SharktopodaData: ObservableObject {
  @Published var udpServer: UDPServer = UDP.server
  @Published var udpClient: UDPClient = UDP.client

  @Published var videoAssets = [String: VideoAsset]()
  
  init() {
    // This allows non-view access to sharktopoda data to update observing views
    UDP.sharktopodaData = self
  }
}
