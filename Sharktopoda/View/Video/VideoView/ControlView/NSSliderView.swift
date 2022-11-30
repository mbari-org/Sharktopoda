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

  var windowData: WindowData {
    get { _windowData! }
    set { attach(windowData: newValue) }
  }
  
  func attach(windowData: WindowData) {
    _windowData = windowData
    
    guard let playerItem = windowData.videoControl.currentItem else { return }
    let syncLayer = AVSynchronizedLayer(playerItem: playerItem)
    
    wantsLayer = true
    layer?.addSublayer(syncLayer)

    // CxInc Initial width is wrong, but gets updated. How and when?
    frame = NSRect(x: 0, y: 0, width: windowData.fullSize.width, height: 30)
//    syncLayer.frame = frame
    
    addMarkerLayer(to: syncLayer)
  }
  
  private func addMarkerLayer(to syncLayer: AVSynchronizedLayer) {
    let markerLayer = CALayer()
    
    let radius = NSHeight(bounds) / 2
    markerLayer.frame = NSRect(x: 0, y: 0, width: radius, height: radius)
    markerLayer.cornerRadius = radius / 2
    markerLayer.backgroundColor = NSColor.white.cgColor
    
    let slideAnimation = CABasicAnimation(keyPath: "position.x")
    slideAnimation.fromValue = markerLayer.position.x
    //    slideAnimation.toValue = NSWidth(bounds) - markerLayer.position.x
    slideAnimation.toValue = 500 - markerLayer.position.x
    slideAnimation.isRemovedOnCompletion = false
    slideAnimation.beginTime = AVCoreAnimationBeginTimeAtZero
//    slideAnimation.duration = CFTimeInterval(windowData.videoAsset.durationMillis)
    slideAnimation.duration = 2.145
    
    markerLayer.add(slideAnimation, forKey: nil)

    
    syncLayer.addSublayer(markerLayer)
    
    
  }
  
  func setupTest() {
  }
  
}
