//
//  PlayerView.swift
//  Created for Sharktopoda on 10/31/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVKit
import SwiftUI

struct PlayerView: NSViewRepresentable {
  let sharktopodaData: SharktopodaData
  
  let nsPlayerView: NSPlayerView
  
  init(videoAsset: VideoAsset, sharktopodaData: SharktopodaData) {
    nsPlayerView = NSPlayerView(videoAsset: videoAsset)
    self.sharktopodaData = sharktopodaData
  }
  
  func makeNSView(context: Context) -> some NSView {
    return nsPlayerView
  }
  
  func updateNSView(_ nsView: NSViewType, context: Context) {}
  
  var currentTime: Int {
    nsPlayerView.currentTime
  }
  
  func displayPaused() {
    nsPlayerView.displayPaused()
  }
  
  var id: String {
    videoAsset.id
  }
  
  var player: AVPlayer {
    nsPlayerView.player
  }
  
  var playerLayer: AVPlayerLayer {
    nsPlayerView.playerLayer
  }
  
  var showLocalizations: Bool {
    nsPlayerView.showLocalizations
  }
  
  var videoAsset: VideoAsset {
    nsPlayerView.videoAsset
  }
  
  var videoRect: CGRect {
    nsPlayerView.videoRect
  }
}
