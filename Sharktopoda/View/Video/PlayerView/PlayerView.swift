//
//  PlayerView.swift
//  Created for Sharktopoda on 10/31/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit
import SwiftUI

final class PlayerView: NSViewRepresentable {
  let videoAsset: VideoAsset
  let nsPlayerView: NSPlayerView
  
  init(videoAsset: VideoAsset) {
    self.videoAsset = videoAsset
    nsPlayerView = NSPlayerView(videoAsset: videoAsset)
  }
  
  func makeNSView(context: Context) -> some NSView {
    return nsPlayerView
  }
  
  func updateNSView(_ nsView: NSViewType, context: Context) {
    
  }
  
}
