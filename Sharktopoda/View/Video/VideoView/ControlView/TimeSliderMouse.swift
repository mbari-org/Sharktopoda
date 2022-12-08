//
//  TimeSliderMouse.swift
//  Created for Sharktopoda on 11/30/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit
import AVFoundation

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
    windowData.pause(false)
    windowData.playerView.clear()
  }
  
  override func mouseDragged(with event: NSEvent) {
    let quickTime = sliderTime(for: event)
    windowData.videoControl.quickSeek(to: quickTime)
  }
  
  override func mouseUp(with event: NSEvent) {
    let frameTime = sliderTime(for: event)
    windowData.videoControl.frameSeek(to: frameTime) { [weak windowData] done in
      guard done else { return }
      
      windowData?.playerResume()
    }
  }

  private func location(in layer: CALayer, of event: NSEvent) -> CGPoint {
    guard let windowLayer = windowLayer else { return .infinity }
    let windowPoint = event.locationInWindow
    return layer.convert(windowPoint, from: windowLayer)
  }

  private func onMarker(_ mousePoint: CGPoint) -> Bool {
    let markerWidth = markerLayer.bounds.width
    let delta = abs(markerX - mousePoint.x)
    return delta < markerWidth / 2
  }
  
  private func sliderTime(for event: NSEvent) -> CMTime {
    let sliderPoint = location(in: layer!, of: event)
    return CMTime.fromMillis(Double(duration) * (sliderPoint.x / bounds.width))
  }
}
