//
//  PlayerViewProxy.swift
//  Created for Sharktopoda on 11/29/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVKit

extension PlayerView {
  func clear() {
    nsPlayerView.clear()
  }
  
  func clear(localizations: [Localization]) {
    nsPlayerView.clear(localizations: localizations)
  }
  
  func display(localization: Localization) {
    nsPlayerView.display(localization: localization)
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
