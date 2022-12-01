//
//  VideoWindowDelegate.swift
//  Created for Sharktopoda on 11/22/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

extension VideoWindow: NSWindowDelegate {
  func windowWillClose(_ notification: Notification) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      self.windowData.player.replaceCurrentItem(with: nil)
      UDP.sharktopodaData.videoWindows.removeValue(forKey: self.id)
    }
  }
  
  func windowDidBecomeKey(_ notification: Notification) {
    windowData.windowKeyInfo = WindowData.WindowKeyInfo(isKey: true)
  }
  
  func windowDidResignKey(_ notification: Notification) {
    windowData.windowKeyInfo = WindowData.WindowKeyInfo(isKey: false)
  }
  
  func windowDidResize(_ notification: Notification) {
    windowData.pause()
    
    let videoRect = windowData.playerView.videoRect
    
    /// Resize paused localizations on main queue to see immediate effect
    let pausedLocalizations = windowData.pausedLocalizations()
    DispatchQueue.main.async { [weak self] in
      self?.windowData.sliderView.setupControlViewAnimation()
      
      for localization in pausedLocalizations {
        localization.resize(for: videoRect)
      }
    }
    
    /// Resize all localizations on background queue. Although paused localizations are resized again,
    /// preventing that would be more overhead than re-resizing.
    queue.async { [weak self] in
      self?.windowData.localizations.resize(for: videoRect)
    }
  }
}
