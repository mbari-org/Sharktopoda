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
    _windowData = windowData

    wantsLayer = true
    layer?.addSublayer(syncLayer)

    syncLayer.playerItem = windowData.player.currentItem
    syncLayer.frame = frame
    
    setupLayers()

  }
  
  private func setupLayers() {
    let radius = NSHeight(bounds) / 2
    markerLayer.frame = NSRect(x: 0, y: 0, width: radius, height: radius)
    markerLayer.cornerRadius = radius / 2
    markerLayer.backgroundColor = NSColor.lightGray.cgColor
    
    syncLayer.addSublayer(markerLayer)

    
  }
  
  func setupAnimations() {
    let slideAnimation = CABasicAnimation(keyPath: "position.x")
    slideAnimation.fromValue = markerLayer.position.x
//    slideAnimation.toValue = NSWidth(bounds) - markerLayer.position.x
    slideAnimation.toValue = 100 - markerLayer.position.x
    slideAnimation.isRemovedOnCompletion = false
    slideAnimation.beginTime = AVCoreAnimationBeginTimeAtZero
    slideAnimation.duration = CFTimeInterval(windowData.videoAsset.durationMillis)
    
    markerLayer.add(slideAnimation, forKey: nil)
  }

  
  
}
