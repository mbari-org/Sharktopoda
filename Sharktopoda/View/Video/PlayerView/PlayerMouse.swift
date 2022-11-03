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
    
    let mousePoint = event.locationInWindow
    
    if event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command {
      if commandSelect(mousePoint) { return }

      startDragSelect(mousePoint)
      return
    }
    
    if let location = clickedCurrentLocalization(mousePoint) {
      currentLocation = location
      print("current with location: \(currentLocation!)")
      return
    }
    
    if let location = currentSelect(mousePoint) {
      currentLocation = location
      print("select with location: \(currentLocation!)")
      return
    }

  }
  
  override func mouseDragged(with event: NSEvent) {
    let mousePoint = event.locationInWindow
    
    /// If there is a current localization, drag it
    if let localization = currentLocalization {
      
      let delta = DeltaPoint(x: event.deltaX, y: event.deltaY)
      dragLocalization(localization, delta: delta)
      return
    }

    /// If there is a select locations layer, drag it
    if selectLayer != nil {
      dragSelect(mousePoint)
    }
  }
  
  override func mouseExited(with event: NSEvent) {
    mouseUp(with: event)
  }
  
  override func mouseUp(with event: NSEvent) {
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
