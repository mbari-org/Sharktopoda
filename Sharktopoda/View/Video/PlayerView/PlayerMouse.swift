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
      if !commandSelect(mousePoint) {
        startDragSelect(mousePoint)
      }
    } else if !clickedCurrentLocalization(mousePoint) {
      mouseSelect(mousePoint)
    }
  }
  
  override func mouseDragged(with event: NSEvent) {
    if let localization = currentLocalization {
      let delta = DeltaPoint(x: event.deltaX, y: event.deltaY)
      dragLocalization(localization, delta: delta)
      return
    }

    if selectPoint != nil {
      dragSelect(event.locationInWindow)
    }

  }
  
  override func mouseExited(with event: NSEvent) {
    dragCurrent = nil
    selectLayer = nil
  }
  
  override func mouseUp(with event: NSEvent) {
    if currentLocalization != nil {
      dragCurrent = nil
      return
    }

    if selectLayer != nil {
      endDragSelect()
    }

  }
}
