//
//  VideoWindowDelegate.swift
//  Created for Sharktopoda on 11/22/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit
import SwiftUI

extension VideoWindow: NSWindowDelegate {
  func windowWillClose(_ notification: Notification) {
    guard let sharktopodaData = UDP.sharktopodaData else { return }
    
    sharktopodaData.releaseWindow(self)
  }
  
  func windowDidBecomeKey(_ notification: Notification) {
    windowData.windowKeyInfo = WindowData.WindowKeyInfo(isKey: true)
  }
  
  func windowDidResignKey(_ notification: Notification) {
    windowData.windowKeyInfo = WindowData.WindowKeyInfo(isKey: false)
  }
  
  func windowWillStartLiveResize(_ notification: Notification) {
    beginResizeWindowData()
  }
  
  func windowDidEndLiveResize(_ notification: Notification) {
    endResizeWindowData()
  }
  
  // CxNote A number of strategies were attempted to facilitate localization repositioning when
  // going full screen *and* when changing the screen. Tracking just windowDidChangeScreen
  // handles both cases *except* that when going full screen, the currently displayed localizations
  // are not "removed" before the window resizes, but only *after* the fact. However, no strategy
  // was found to remove the localizations *before* going full screen.
  func windowDidChangeScreen(_ notification: Notification) {
    print("Changed screen")
    beginResizeWindowData()
    endResizeWindowData()
  }
  
  func beginResizeWindowData() {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      let windowData = self.windowData
      
      self.playerDirection = windowData.playerDirection
      windowData.videoControl.play(rate: 0.0)
      windowData.playerView.clear()
      windowData.localizationData.clearSelected()
    }
  }
  
  func endResizeWindowData() {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      let windowData = self.windowData
      
      let videoRect = windowData.playerView.videoRect
    
      // When the window is closed, the video rect will be zero and nothing more need be done
      guard videoRect != .zero else { return }
      
      let pausedLocalizations = windowData.pausedLocalizations()
      
      for localization in pausedLocalizations {
        localization.resize(for: videoRect)
      }
      
      windowData.sliderView.setupControlViewAnimation()
      windowData.playerResume(self.playerDirection ?? .paused)
    }
  }
}
