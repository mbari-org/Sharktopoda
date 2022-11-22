//
//  VideoWindowDelegate.swift
//  Created for Sharktopoda on 11/22/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

extension VideoWindow: NSWindowDelegate {
  func windowWillClose(_ notification: Notification) {
    let videoId = videoAsset.id
    DispatchQueue.main.async {
      UDP.sharktopodaData.videoWindows.removeValue(forKey: videoId)
    }
  }
  
  func windowDidBecomeKey(_ notification: Notification) {
    keyInfo = KeyInfo(keyTime: Date(), isKey: true)
  }
  
  func windowDidResignKey(_ notification: Notification) {
    keyInfo = KeyInfo(keyTime: keyInfo.keyTime, isKey: false)
  }
  
  func windowDidResize(_ notification: Notification) {
    playerControl.pause()
    
    let videoRect = playerView.videoRect
    
    /// Resize paused localizations on main queue to see immediate effect
    let pausedLocalizations = localizations.fetch(.paused, at: playerControl.currentTime)
    DispatchQueue.main.async {
      for localization in pausedLocalizations {
        localization.resize(for: videoRect)
      }
    }
    
    /// Resize all localizations on background queue. Although paused localizations are resized again,
    /// preventing that would be more overhead than re-resizing.
    queue.async {
      self.localizations.resize(for: videoRect)
    }
  }
}
