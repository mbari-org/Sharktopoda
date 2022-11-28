//
//  VideoWindowPlayerObserver.swift
//  Created for Sharktopoda on 11/22/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

extension VideoWindow {
  func setLocalizationsObserver(_ pollingInterval: CMTime) {
    videoControl.player.addPeriodicTimeObserver(forInterval: pollingInterval,
                                                 queue: queue) { [weak self] time in
      guard self?.playerView.showLocalizations ?? false else { return }
      
      guard let localizations = self?.localizations,
            let videoControl = self?.videoControl,
            let playerView = self?.playerView else { return }

      let elapsedTime = time.asMillis()
      let direction = videoControl.playerDirection
      let opposite = direction.opposite()

      playerView.display(localizations: localizations.fetch(direction, at: elapsedTime))
      playerView.clear(localizations: localizations.fetch(opposite, at: elapsedTime))
      
      DispatchQueue.main.async {
        videoControl.playerTime = elapsedTime
      }
    }
  }
}
