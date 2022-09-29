//
//  VideoPlayerView.swift
//  Created for Sharktopoda on 9/29/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVKit
import SwiftUI

final class VideoPlayerView: NSViewRepresentable {
  let avPlayerView: AVPlayerView

  init(for avPlayer: AVPlayer) {
    avPlayerView = AVPlayerView()
    avPlayerView.controlsStyle = .inline
    avPlayerView.player = avPlayer
  }
  
  func makeNSView(context: Context) -> some NSView {
    return avPlayerView
  }
  
  func updateNSView(_ nsView: NSViewType, context: Context) {
    print("CxInc updateNSView")
  }
}
