//
//  PlayerView.swift
//  Created for Sharktopoda on 10/31/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVKit
import SwiftUI

struct PlayerView: NSViewRepresentable {
  @EnvironmentObject private var windowData: WindowData
  
  var nsPlayerView = NSPlayerView()
  
  func makeNSView(context: Context) -> some NSView {
    nsPlayerView.windowData = windowData
    return nsPlayerView
  }
  
  func updateNSView(_ nsView: NSViewType, context: Context) {}
}
 
extension PlayerView {
  func clear() {
    nsPlayerView.clear()
  }

  func clear(localizations: [Localization]) {
    nsPlayerView.clear(localizations: localizations)
  }

  func clearConcept() {
    nsPlayerView.conceptLayer?.removeFromSuperlayer()
  }
  
  var currentTime: Int {
    nsPlayerView.currentTime
  }
  
  func display(localizations: [Localization]) {
    nsPlayerView.display(localizations: localizations)
  }

  var playerLayer: AVPlayerLayer {
    nsPlayerView.playerLayer
  }
  
  var showLocalizations: Bool {
    nsPlayerView.showLocalizations
  }
  
  var videoRect: CGRect {
    nsPlayerView.videoRect
  }
}

extension PlayerView {
  func display(localization: Localization) {
    guard nsPlayerView.showLocalizations else { return }

    DispatchQueue.main.async {
      playerLayer.addSublayer(localization.layer)
    }
  }
}
