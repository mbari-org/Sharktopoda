//
//  VideoAssetLocalizations.swift
//  Created for Sharktopoda on 11/18/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

extension VideoAsset {
  func addLocalization(_ localization: Localization, time currentTime: Int) -> Bool {
    // CxInc Needs to happen before adding
//    localization.resize(for: videoRect)

    guard let localizations = localizations,
          localizations.add(localization) else { return false }

    // CxInc
//    guard paused else { return true }

    // CxInc Needs happen in caller

//    let currentFrameNumber = localizations.frameNumber(elapsedTime: currentTime)
//    let localizationFrameNumber = localizations.frameNumber(for: localization)
//    if showLocalizations,
//       currentFrameNumber == localizationFrameNumber {
//      DispatchQueue.main.async { [weak self] in
//        self?.playerLayer.addSublayer(localization.layer)
//      }
//    }
    
    return true
  }
  
  func clearLocalizations() {
    guard let localizations = localizations else { return }
    
    // CxInc
//    clearLocalizationLayers()
    
    localizations.clear()
  }
  
  func removeLocalizations(_ ids: [String]) -> [Bool] {
    guard localizations != nil else {
      return ids.map { _ in false }
    }
    
    let result = ids.map { localizations!.remove(id: $0) }
    // CxInc
//    displayPaused()
    return result
  }
  
  func deleteSelected() -> Bool {
    guard let localizations = localizations else { return false }
    
    // CxInc
//    conceptLayer?.removeFromSuperlayer()
    return localizations.deleteSelected()
  }
  
  func selectLocalizations(_ ids: [String]) -> [Bool] {
    guard let localizations = localizations else {
      return Array(repeating: false, count: ids.count)
    }
    
    return localizations.select(ids: ids)
  }
  
  func updateLocalization(_ control: ControlLocalization) -> Bool {
    guard localizations != nil else { return false }
    
    let result = localizations!.update(using: control)
    
    // CxInc
//    displayPaused()
    return result
  }
}
