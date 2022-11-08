//
//  LocalizationMouse.swift
//  Created for Sharktopoda on 11/2/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

extension NSPlayerView {
  
  /// Check if mouse click is inside the current localization layer
  func clickedCurrentLocalization(_ mousePoint: CGPoint) -> CGRect.Location? {
    guard let mouseLayer = currentLocalization?.layer else { return nil }
    
    let layerPoint = mouseLayer.convertSuperPoint(mousePoint)
    /// If did not click in current location mouse layer, unselect any potentially selected locatizations
    guard mouseLayer.contains(layerPoint) else {
      if let id = currentLocalization?.id {
        localizations?.unselect(id: id)
        currentLocalization = nil
      }
      return nil
    }
    
    /// Return where inside the current localization the mouse click occurred
    return mouseLayer.location(of: layerPoint)
  }
  
  /// Process command click for selecting a Localization
  func commandSelect(_ mousePoint: CGPoint) -> Bool {
    guard let localizations = localizations else { return false }
    guard localizations.areSelected() else { return false }
    guard let mouseLocalization = mousedLocalization(at: mousePoint) else { return false }
    
    currentLocalization = nil
    
    return localizations.select(id: mouseLocalization.id, clear: false)
  }
  
  /// Process click to see if and where a click occurred in a Localization
  func currentSelect(_ mousePoint: CGPoint) -> CGRect.Location? {
    guard let mouseLocalization = mousedLocalization(at: mousePoint) else {
      currentLocalization = nil
      localizations?.clearSelected()
      return nil
    }
    
    let _ = localizations?.select(id: mouseLocalization.id) 
    let layer = mouseLocalization.layer
    let layerPoint = layer.convertSuperPoint(mousePoint)
    currentLocalization = mouseLocalization
    return layer.location(of: layerPoint)
  }
  
  /// Find the Localization that both contains the point and has the closest edge
  private func mousedLocalization(at point: NSPoint) -> Localization? {
    guard paused else { return nil }
    guard showLocalizations else { return nil }
    guard let pausedLocalizations = localizations?.fetch(.paused, at: currentTime) else { return nil }
    guard !pausedLocalizations.isEmpty else { return nil }
    
    let mousedLocalizations = pausedLocalizations.filter {
      $0.layer.containsSuperPoint(point)
    }
    guard !mousedLocalizations.isEmpty else { return nil }
    
    return mousedLocalizations.min { a, b in
      let aDistance = a.layer.frame.minSideDistance(point: point)
      let bDistance = b.layer.frame.minSideDistance(point: point)
      return aDistance < bDistance
    }!
  }
}
