//
//  NSSliderView.swift
//  Created for Sharktopoda on 11/29/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit
import AVFoundation
import SwiftUI

final class NSTimeSliderView: NSView {
  // MARK: properties
  var _windowData: WindowData? = nil

  let markerLayer = CALayer()

  var minX: CGFloat = 0
  var maxX: CGFloat = .infinity
  var maxTime: Int = 0
  
  var dragPoint: CGPoint? = nil

  var windowData: WindowData {
    get { _windowData! }
    set { attach(windowData: newValue) }
  }
  
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
    
    minX = markerLayer.position.x
    maxX = NSWidth(bounds) - minX
    maxTime = Int(windowData.videoAsset.duration.seconds)
    
    let slideAnimation = CABasicAnimation(keyPath: "position.x")
    slideAnimation.fromValue = minX
    slideAnimation.toValue = maxX
    slideAnimation.isRemovedOnCompletion = false
    slideAnimation.beginTime = AVCoreAnimationBeginTimeAtZero
    slideAnimation.duration = CFTimeInterval(maxTime)
    
    markerLayer.add(slideAnimation, forKey: windowData.id)
  }
  
}
