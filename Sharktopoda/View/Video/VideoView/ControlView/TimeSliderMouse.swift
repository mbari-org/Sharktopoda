//
//  TimeSliderMouse.swift
//  Created for Sharktopoda on 11/30/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

extension NSTimeSliderView {
  
  var markerX: CGFloat {
    (CGFloat(windowData.playerTime) / CGFloat(duration)) * bounds.width
  }

  var windowLayer: CALayer? {
    // CxTBD Investigate
    layer?.superlayer?.superlayer?.superlayer
  }

  // CxNote The animated markerLayer position value is not reflected in markerLayer.position itself,
  // so we have to calculate where the marker actually is using playerTime and duration.
  override func mouseDown(with event: NSEvent) {
    guard windowData.videoControl.paused else {
      dragPoint = nil
      return
    }
    
    let mousePoint = location(in: layer!, of: event)
    if onMarker(mousePoint) {
      dragPoint = CGPoint(x: markerX, y: bounds.height / 2)
    }
  }
  
  override func mouseDragged(with event: NSEvent) {
    let mousePoint = location(in: layer!, of: event)
    jump(toPoint: mousePoint)
  }
  
  override func mouseUp(with event: NSEvent) {
    let mousePoint = location(in: layer!, of: event)
    
    guard !onMarker(mousePoint) else {
      dragPoint = nil
      return
    }
    
    jump(toPoint: mousePoint)
  }

  private func location(in layer: CALayer, of event: NSEvent) -> CGPoint {
    guard let windowLayer = windowLayer else { return .infinity }
    let windowPoint = event.locationInWindow
    return layer.convert(windowPoint, from: windowLayer)
  }
  
  private func jump(toPoint mousePoint: CGPoint) {
    let markerTime = Int(Double(duration) * (mousePoint.x / bounds.width))
    windowData.playerView.clear()
    windowData.videoControl.seek(elapsedTime: markerTime) { _ in }
  }
  
  private func onMarker(_ mousePoint: CGPoint) -> Bool {
    let markerWidth = markerLayer.bounds.width
    let delta = abs(markerX - mousePoint.x)
    return delta < markerWidth / 2
  }
}
