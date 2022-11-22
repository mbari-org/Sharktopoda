//
//  VideoWindowMisc.swift
//  Created for Sharktopoda on 11/22/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

extension VideoWindow {
  override func makeKeyAndOrderFront(_ sender: Any?) {
    super.makeKeyAndOrderFront(sender)
    self.keyInfo = KeyInfo(keyTime: Date(), isKey: true)
  }
}

extension VideoWindow {
  func advance(steps: Int) {
    
    DispatchQueue.main.async { [weak self] in
      self?.localizations.clearSelected()
      self?.playerView.clear()
    }
    
    playerControl.step(steps)
    
    let pausedLocalizations = localizations.fetch(.paused, at: playerControl.currentTime)
    DispatchQueue.main.async { [weak self] in
      self?.playerView.display(localizations: pausedLocalizations)
    }
  }
}
