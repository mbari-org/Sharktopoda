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
    guard let currentLayer = currentLocalization?.layer else { return nil }
    
    let layerPoint = currentLayer.convertSuperPoint(mousePoint)
    /// If did not click in current location mouse layer, unselect any potentially selected locatizations
    guard currentLayer.contains(layerPoint) else {
      if let id = currentLocalization?.id {
        localizationData.unselect(ids: [id])
        currentLocalization = nil
      }
      return nil
    }
    
    /// Return location inside the current localization where the mouse click occurred
    return currentLayer.location(of: layerPoint)
  }
  
  /// Process command click for selecting a Localization
  func commandSelect(at playerPoint: CGPoint) -> Bool {
    guard let mouseLocalization = mousedLocalization(at: playerPoint) else {
      return false
    }

    windowData.localizationData.select(ids: [mouseLocalization.id])
//    displayConcept(for: mouseLocalization)

    return true
  }
  
  /// Process click to see if and where a click occurred in a Localization
  func currentSelect(_ mousePoint: CGPoint) -> CGRect.Location? {
    guard let mouseLocalization = mousedLocalization(at: mousePoint) else {
      currentLocalization = nil
      localizationData.clearSelected()
      return nil
    }
    
    localizationData.clearSelected(notifyClient: false)

    currentLocalization = mouseLocalization
    localizationData.select(ids: [mouseLocalization.id])
//    displayConcept(for: mouseLocalization)

    let layer = mouseLocalization.layer
    let layerPoint = layer.convertSuperPoint(mousePoint)
    return layer.location(of: layerPoint)
  }
  
  func region(from layer: CAShapeLayer) -> CGRect {
    var layerFrame = layer.frame
    if !videoRect.contains(layerFrame) {
      // Clip layer
      layerFrame = videoRect.intersection(layerFrame)
      CALayer.noAnimation {
        layer.shapeFrame(layerFrame)
      }
    }

    let scale = fullSize.width / videoRect.width
    
    let regionX = (layerFrame.minX - videoRect.minX) * scale
    let regionY = fullSize.height - (layerFrame.maxY - videoRect.minY) * scale
    let regionSize = layerFrame.size.scale(by: scale)
    
    return CGRect(origin: CGPoint(x: regionX, y: regionY),
                   size: regionSize)
  }
  
  /// Find the Localization that both contains the point and has the closest edge
  private func mousedLocalization(at point: NSPoint) -> Localization? {
    guard windowData.videoControl.paused else { return nil }
    guard showLocalizations else { return nil }

    let mousedLocalizations = localizationData
      .fetch(spanning: currentTime)
      .filter { $0.layer.containsSuperPoint(point) }
    
    guard !mousedLocalizations.isEmpty else { return nil }
    
    return mousedLocalizations.min { a, b in
      let aDistance = a.layer.frame.minSideDistance(point: point)
      let bDistance = b.layer.frame.minSideDistance(point: point)
      return aDistance < bDistance
    }!
  }
}
