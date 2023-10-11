//
//  NSTimeSlider
//  Created for Sharktopoda on 11/29/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit
import AVFoundation
import SwiftUI

final class NSTimeSlider: NSView {
  // MARK: properties
  var _windowData: WindowData? = nil

  let markerLayer = CALayer()

  var duration: Int {
    windowData.videoAsset.durationMillis
  }
  
  /// Hold current player direction during slider scrubbing
  var playerDirection: WindowData.PlayerDirection?
  
  var windowData: WindowData {
    get { _windowData! }
    set { attach(windowData: newValue) }
  }
  
  func attach(windowData: WindowData) {
    _windowData = windowData
    
    frame = NSRect(x: 0, y: 0, width: windowData.videoAsset.fullSize.width, height: 40)

    guard let playerItem = windowData.videoControl.currentItem else { return }
    let syncLayer = AVSynchronizedLayer(playerItem: playerItem)
    
    wantsLayer = true
    layer?.addSublayer(syncLayer)
    
    addMarkerLayer(to: syncLayer)
  }
  
  var radius: CGFloat {
    NSHeight(bounds) / 2
  }

  override func draw(_ dirtyRect: NSRect) {
    NSColor.darkGray.set()
//    NSColor(red: 71, green: 64, blue: 61, alpha: 1.0).set()
    let horizontalLine = NSBezierPath()
    horizontalLine.move(to: NSMakePoint(0, radius))
    horizontalLine.line(to: NSMakePoint(frame.width, radius))
    horizontalLine.lineWidth = 4
    horizontalLine.stroke()  // draw line
  }

  private func addMarkerLayer(to syncLayer: AVSynchronizedLayer) {
    markerLayer.frame = NSRect(x: 0, y: 0, width: radius, height: radius)
    markerLayer.cornerRadius = radius / 2
    markerLayer.backgroundColor = NSColor.systemGray.cgColor
    syncLayer.addSublayer(markerLayer)
  }

  func setupControlViewAnimation() {
    markerLayer.removeAllAnimations()
    
    let halfWidth = markerLayer.bounds.width / 2
    
    let slideAnimation = CABasicAnimation(keyPath: "position.x")
    slideAnimation.fromValue = halfWidth
    slideAnimation.toValue = layer!.bounds.width - halfWidth
    slideAnimation.isRemovedOnCompletion = false
    slideAnimation.beginTime = AVCoreAnimationBeginTimeAtZero
    slideAnimation.duration = CFTimeInterval(windowData.videoAsset.duration.seconds)
    
    markerLayer.add(slideAnimation, forKey: windowData.id)
  }
  
}
