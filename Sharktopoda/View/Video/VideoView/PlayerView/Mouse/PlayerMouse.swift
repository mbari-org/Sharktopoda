//
//  VPVMouse.swift
//  Created for Sharktopoda on 10/31/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

extension NSPlayerView {
  override func mouseDown(with event: NSEvent) {
    guard windowData.videoControl.paused else { return }
    
    let playerPoint = location(in: playerLayer, of: event)
    guard videoRect.contains(playerPoint) else { return }
    
    dragAnchor = playerPoint

    if event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command {
      if let localization = currentLocalization {
        currentLocalization = nil
        if localizations.select(id: localization.id),
           let conceptLayer = localization.conceptLayer {
          localization.positionConcept(for: videoRect)
          playerLayer.addSublayer(conceptLayer)
        }
      }
      
      if commandSelect(at: playerPoint) { return }
      
      localizations.clearSelected()
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
    let playerPoint = location(in: playerLayer, of: event)
    
    /// If there is a current localization, drag it
    if currentLocation != nil {
      let delta = DeltaPoint(x: event.deltaX, y: event.deltaY)
      dragCurrent(by: delta)
      return
    }

    dragPurpose(using: playerPoint)
  }
  
  override func mouseUp(with event: NSEvent) {
    let endPoint = location(in: playerLayer, of: event)
    
    if event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command {
      endDragPurpose(at: endPoint)
    }
    
    currentLocalization != nil ? endDragCurrent(at: endPoint) : endDragPurpose(at: endPoint)
    
//    if let localization = currentLocalization,
//       localizations.select(id: localization.id),
//       let conceptLayer = localization.conceptLayer {
//      localization.positionConcept(for: videoRect)
//      playerLayer.addSublayer(conceptLayer)
//    }
    
    dragAnchor = nil
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

  private func location(in layer: CALayer, of event: NSEvent) -> CGPoint {
    // CxTBD Investigate
    guard let windowLayer = rootLayer.superlayer?.superlayer?.superlayer else { return .infinity }

    let windowPoint = event.locationInWindow
    return layer.convert(windowPoint, from: windowLayer)
  }
  
//  func displayConcept(_ localization: Localization) {
//    guard let conceptLayer = conceptLayer else { return }
//    
//    let lineWidth = localization.layer.lineWidth
//    
//    conceptLayer.string = localization.concept
//    let layerFrame = localization.layer.frame
//    var conceptFrame = CGRect(x: layerFrame.minX, y: layerFrame.maxY + lineWidth, width: 100, height: 15)
//
//    if videoRect.maxY < conceptFrame.maxY {
//      let deltaY = -(layerFrame.height + conceptFrame.height + lineWidth)
//      conceptFrame = conceptFrame.move(by: DeltaPoint(x: 0, y: deltaY))
//    }
//    DispatchQueue.main.async {
//      CALayer.noAnimation {
//        conceptLayer.frame = conceptFrame
//      }
//    }
//
//    playerLayer.addSublayer(conceptLayer)
//  }
}
