//
//  VideoValues.swift
//  Created for Sharktopoda on 11/22/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct VideoValues {
  var rate: Float = 0.0
  
  mutating func playRate(_ playRate: Float) {
    rate = playRate
  }
}

extension VideoWindow {
  /// Pause while saving previous play rate value
  func pause() {
    videoValues.playRate(playerControl.rate)
    playerControl.pause()
  }
}
