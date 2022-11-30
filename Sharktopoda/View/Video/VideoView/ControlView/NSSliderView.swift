//
//  NSSliderView.swift
//  Created for Sharktopoda on 11/29/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit
import AVFoundation

final class NSSliderView: NSView {
  // MARK: properties
  var _windowData: WindowData? = nil
  
  let markerLayer = CALayer()
  let syncLayer = AVSynchronizedLayer()
  let timeLineLayer = CALayer()

  var windowData: WindowData {
    get { _windowData! }
    set { attach(windowData: newValue) }
  }
  
  func attach(windowData: WindowData) {
    wantsLayer = true

    syncLayer.playerItem = windowData.player.currentItem
    syncLayer.frame = frame
    
    setupMarkerLayer()

    layer?.addSublayer(syncLayer)
    
    
    _windowData = windowData
    
  }
  
  private func setupMarkerLayer() {
    let radius = NSHeight(bounds) / 2
    markerLayer.frame = NSRect(x: 0, y: 0, width: radius, height: radius)
    markerLayer.cornerRadius = radius / 2
    markerLayer.backgroundColor = NSColor.white.cgColor
    syncLayer.addSublayer(markerLayer)
  }
  
  private func setupTimeLineLayer() {
    timeLineLayer.frame = syncLayer.bounds
    
  }

  
  
}
