//
//  PlayerView.swift
//  Created for Sharktopoda on 10/31/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVKit
import SwiftUI

struct PlayerView: NSViewRepresentable {
  let playerView: AVPlayerView
  
  init(videoAsset: VideoAsset) {
    playerView = AVPlayerView()
  }
  
  func makeNSView(context: Context) -> some NSView {
    return playerView
  }
  
  func updateNSView(_ nsView: NSViewType, context: Context) {}
  
}
