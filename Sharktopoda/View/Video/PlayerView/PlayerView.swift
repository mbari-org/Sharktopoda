//
//  PlayerView.swift
//  Created for Sharktopoda on 10/31/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVKit
import SwiftUI

struct PlayerView: NSViewRepresentable {
//  @EnvironmentObject
  
  let nsPlayerView: NSPlayerView
  
  init(videoAsset: VideoAsset) {
    nsPlayerView = NSPlayerView(videoAsset: videoAsset)
  }
  
  func makeNSView(context: Context) -> some NSView {
    return nsPlayerView
  }
  
  func updateNSView(_ nsView: NSViewType, context: Context) {}
  
  var currentTime: Int {
    nsPlayerView.currentTime
  }
  
  var player: AVPlayer {
    nsPlayerView.player
  }
  
  var videoAsset: VideoAsset {
    nsPlayerView.videoAsset
  }
  
  var videoRect: CGRect {
    nsPlayerView.videoRect
  }
}
