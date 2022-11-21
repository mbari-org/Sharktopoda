//
//  LocalizationsControl.swift
//  Created for Sharktopoda on 11/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct LocalizationsControl {
  let localizations: Localizations

  func addLocalization(_ localization: Localization, time currentTime: Int) {
    // CxInc Needs to happen before adding
    //    localization.resize(for: videoRect)
    localizations.add(localization)
    
    // CxInc Needs happen in caller
//    guard paused else { return }
//
//    let currentFrameNumber = localizations.frameNumber(elapsedTime: currentTime)
//    let localizationFrameNumber = localizations.frameNumber(for: localization)
//    if showLocalizations,
//       currentFrameNumber == localizationFrameNumber {
//      DispatchQueue.main.async { [weak self] in
//        self?.playerLayer.addSublayer(localization.layer)
//      }
//    }
  }
  
  func clearLocalizations() {
    localizations.clear()
  }
  
  func clearSelected() {
    localizations.clearSelected()
  }
  
  func removeLocalizations(_ ids: [String]) {
    ids.forEach { localizations.remove(id: $0) }

    // CxInc Needs happen in caller
    //    displayPaused()
    }

  func deleteSelected() {
      // CxInc Needs happen in caller
    //    conceptLayer?.removeFromSuperlayer()
    localizations.deleteSelected()
  }

  func selectLocalizations(_ ids: [String]) {
    localizations.select(ids: ids)
  }
  
  func updateLocalization(_ control: ControlLocalization) {
    localizations.update(using: control)
    
    // CxInc Needs happen in caller
    //    displayPaused()

  }
}
