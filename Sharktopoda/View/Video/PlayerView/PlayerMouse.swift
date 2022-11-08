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
    
    dragAnchor = event.locationInWindow

    if event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command {
      if commandSelect(dragAnchor!) { return }
      startDragSelect(with: dragAnchor!)
      return
    }
    
    if let location = clickedCurrentLocalization(dragAnchor!) {
      setCurrentLocation(location)
      return
    }
    
    if let location = currentSelect(dragAnchor!) {
      setCurrentLocation(location)
      return
    }
  }
  
  private func setCurrentLocation(_ location: CGRect.Location) {
    currentLocation = location
    currentFrame = currentLocalization?.layer.frame
  }
  
  override func mouseDragged(with event: NSEvent) {
    let mousePoint = event.locationInWindow
    
    if currentLocation != nil {
      /// If there is a current localization, drag it
      let delta = DeltaPoint(x: event.deltaX, y: event.deltaY)
      dragCurrent(by: delta)
    } else if selectLayer != nil {
      /// If there is a select locations layer, drag it
      dragSelect(using: mousePoint)
    }
  }
  
  override func mouseExited(with event: NSEvent) {
    mouseUp(with: event)
  }
  
  override func mouseUp(with event: NSEvent) {
    dragAnchor = nil
    currentFrame = nil
    
    if currentLocalization != nil {
      // CxInc Send update to UDP controller
      currentLocation = nil
      return
    }

    if selectLayer != nil {
      endDragSelect()
    }

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
}
