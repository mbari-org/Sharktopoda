//
//  PlayerView.swift
//  Created for Sharktopoda on 10/31/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVKit
import SwiftUI

struct PlayerView: NSViewRepresentable {
//  @EnvironmentObject var playerControl: PlayerControl
  
  let id: String

  let localizations: Localizations
  let nsPlayerView: NSPlayerView
  
  init(id: String,
       localizations: Localizations,
       playerControl: PlayerControl) {
    self.id = id
    self.localizations = localizations
  
    nsPlayerView = NSPlayerView(playerControl: playerControl)
  }
  
  func makeNSView(context: Context) -> some NSView {
    return nsPlayerView
  }
  
  func updateNSView(_ nsView: NSViewType, context: Context) {}

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
