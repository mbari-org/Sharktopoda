//
//  NSSliderView.swift
//  Created for Sharktopoda on 11/29/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit
import AVFoundation
import SwiftUI

final class NSSliderView: NSView {
  // MARK: properties
  var _windowData: WindowData? = nil
  
  var windowData: WindowData {
    get { _windowData! }
    set { attach(windowData: newValue) }
  }
  
  let markerLayer = CALayer()
  
  func attach(windowData: WindowData) {
    _windowData = windowData
    
    frame = NSRect(x: 0, y: 0, width: windowData.fullSize.width, height: 30)

    guard let playerItem = windowData.videoControl.currentItem else { return }
    let syncLayer = AVSynchronizedLayer(playerItem: playerItem)
    
    wantsLayer = true
    layer?.addSublayer(syncLayer)

    // CxInc Initial width is wrong, but gets updated. How and when?
//    syncLayer.frame = frame
    
    addMarkerLayer(to: syncLayer)
  }
  
  var radius: CGFloat {
    NSHeight(bounds) / 2
  }

  override func draw(_ dirtyRect: NSRect) {
    NSColor.lightGray.set()
    let horizontalLine = NSBezierPath()
    horizontalLine.move(to: NSMakePoint(0, radius))
    horizontalLine.line(to: NSMakePoint(frame.width, radius))
    horizontalLine.lineWidth = 3
    horizontalLine.stroke()  // draw line
  }

  private func addMarkerLayer(to syncLayer: AVSynchronizedLayer) {
    markerLayer.frame = NSRect(x: 0, y: 0, width: radius, height: radius)
    markerLayer.cornerRadius = radius / 2
    markerLayer.backgroundColor = NSColor.white.cgColor
    syncLayer.addSublayer(markerLayer)
  }

  func setupControlViewAnimation() {
    markerLayer.removeAllAnimations()
    
    let slideAnimation = CABasicAnimation(keyPath: "position.x")
    slideAnimation.fromValue = markerLayer.position.x
    slideAnimation.toValue = NSWidth(bounds) - markerLayer.position.x
    slideAnimation.isRemovedOnCompletion = false
    slideAnimation.beginTime = AVCoreAnimationBeginTimeAtZero
    slideAnimation.duration = CFTimeInterval(windowData.videoAsset.duration.seconds)
    
    markerLayer.add(slideAnimation, forKey: windowData.id)
  }
  
}
