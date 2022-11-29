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
  
  let syncLayer = AVSynchronizedLayer()

  var windowData: WindowData {
    get { _windowData! }
    set { attach(windowData: newValue) }
  }
  
  func attach(windowData: WindowData) {
    syncLayer.playerItem = windowData.player.currentItem
    
    wantsLayer = true
    layer = syncLayer
    
    layer?.backgroundColor = NSColor.white.cgColor
    
    _windowData = windowData
  }

  
  
}
