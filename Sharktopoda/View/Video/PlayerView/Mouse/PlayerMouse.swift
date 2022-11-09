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
      if commandSelect(playerPoint) { return }
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
  
  override func mouseExited(with event: NSEvent) {
    mouseUp(with: event)
  }
  
  override func mouseUp(with event: NSEvent) {
    dragAnchor = nil
    currentFrame = nil
    
    if currentLocalization != nil {
      endDragCurrent()
    } else {
      endDragPurpose()
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
  
  func videoPoint(of playerPoint: CGPoint) -> CGPoint {
    guard playerPoint != .infinity else { return .infinity }
    
    return playerPoint.delta(to: videoRect.origin)
   }
}