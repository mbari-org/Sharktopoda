//
//  VideoWindowPlayerObserver.swift
//  Created for Sharktopoda on 11/22/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

extension VideoWindow {
  func setPlayerObserver(_ pollingInterval: CMTime) {
    windowData.player.addPeriodicTimeObserver(forInterval: pollingInterval,
                                              queue: playerTimeQueue) { [weak self] time in
      guard let windowData = self?.windowData else { return }
      guard windowData.playerView.showLocalizations else { return }
      
      let elapsedTime = time.asMillis()
      let direction = windowData.playerDirection
      let opposite = direction.opposite()
      
      DispatchQueue.main.async { [weak windowData] in
        guard let playerView = windowData?.playerView,
              let localizations = windowData?.localizationData else { return }

        playerView.display(localizations: localizations.fetch(direction, at: elapsedTime))
        playerView.clear(localizations: localizations.fetch(opposite, at: elapsedTime))

        windowData?.playerTime = elapsedTime
      }
    }
    
    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(playerHitEnd),
                   name: .AVPlayerItemDidPlayToEndTime,
                   object: nil
      )
  }
  
  @objc func playerHitEnd(_: NSNotification) {
    windowData.playerDirection = .paused
  }
}
