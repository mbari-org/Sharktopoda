//
//  PlayerViewLocalizations.swift
//  Created for Sharktopoda on 11/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

extension PlayerView {
  func addLocalization(_ localization: Localization) {
    guard nsPlayerView.showLocalizations else { return }
    guard let localizations = sharktopodaData.localizations(id: id) else { return }
            
    let currentFrameNumber = localizations.frameNumber(elapsedTime: currentTime)
    let localizationFrameNumber = localizations.frameNumber(for: localization)

    guard currentFrameNumber == localizationFrameNumber else { return }

    DispatchQueue.main.async {
      playerLayer.addSublayer(localization.layer)
    }
  }
  
  func clearLocalizations() {
    nsPlayerView.clearLocalizationLayers()
  }
}
