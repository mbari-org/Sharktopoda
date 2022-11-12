//
//  VPVMouse.swift
//  Created for Sharktopoda on 10/31/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

extension NSPlayerView {
  override func mouseDown(with event: NSEvent) {
    pause()
    
    let playerPoint = locationInPlayer(with: event)
    guard videoRect.contains(playerPoint) else { return }
    
    dragAnchor = playerPoint

    if event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command {
      if let localization = currentLocalization {
        currentLocalization = nil
        let _ = localizations?.select(id: localization.id)
      }
      
      if commandSelect(at: playerPoint) { return }
      
      localizations?.clearSelected()
      startDragPurpose(.select)
      return
    }
    
    if let location = clickedCurrentLocalization(playerPoint) {
      setCurrentLocation(location)
      return
    }
    
    if let location = currentSelect(playerPoint) {
      setCurrentLocation(location)
      return
    }
    
    startDragPurpose(.create)
  }
  
  override func mouseDragged(with event: NSEvent) {
    let playerPoint = locationInPlayer(with: event)
    
    if currentLocation != nil {
      /// If there is a current localization, drag it
      let delta = DeltaPoint(x: event.deltaX, y: event.deltaY)
      dragCurrent(by: delta)
      return
    }

    dragPurpose(using: playerPoint)
  }
  
  override func mouseUp(with event: NSEvent) {
    let endPoint = locationInPlayer(with: event)
    
    if event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command {
      endDragPurpose(at: endPoint)
    }
    
    if currentLocalization != nil {
      endDragCurrent(at: endPoint)
    } else {
      currentLocalization = nil
      endDragPurpose(at: endPoint)
    }
    
    dragAnchor = nil
    
    if let localization = currentLocalization {
      displayConcept(localization)
    } else {
      conceptLayer?.removeFromSuperlayer()
    }
    
  }
  
  private func setCurrentLocation(_ location: CGRect.Location) {
    currentLocation = location
    currentFrame = currentLocalization?.layer.frame
  }
  
  override func updateTrackingAreas() {
    super.updateTrackingAreas()
    
    for trackingArea in trackingAreas {
      removeTrackingArea(trackingArea)
    }
    
    let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways]
    let trackingArea = NSTrackingArea(rect: bounds, options: options, owner: self, userInfo: nil)
    addTrackingArea(trackingArea)
  }

  private func locationInPlayer(with event: NSEvent) -> CGPoint {
    guard let windowLayer = rootLayer.superlayer?.superlayer?.superlayer else { return .infinity }
    
    let windowPoint = event.locationInWindow
    return playerLayer.convert(windowPoint, from: windowLayer)
  }
  
  func displayConcept(_ localization: Localization) {
    guard let conceptLayer = conceptLayer else { return }
    
    conceptLayer.string = localization.concept
    let layerFrame = localization.layer.frame
    var conceptFrame = CGRect(x: layerFrame.minX, y: layerFrame.maxY, width: 100, height: 15)
    
    if videoRect.maxY < conceptFrame.maxY {
      let deltaY = -(layerFrame.height + conceptFrame.height)
      conceptFrame = conceptFrame.move(by: DeltaPoint(x: 0, y: deltaY))
    }
    DispatchQueue.main.async {
      CALayer.noAnimation {
        conceptLayer.frame = conceptFrame
      }
    }

    playerLayer.addSublayer(conceptLayer)
  }
}
