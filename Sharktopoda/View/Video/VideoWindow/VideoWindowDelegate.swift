//
//  VideoWindowDelegate.swift
//  Created for Sharktopoda on 11/22/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

extension VideoWindow: NSWindowDelegate {
  func windowWillClose(_ notification: Notification) {
    Task {
      await UDP.sharktopodaData.closeVideo(id: id)
    }
  }
  
  func windowDidBecomeKey(_ notification: Notification) {
    windowData.windowKeyInfo = WindowData.WindowKeyInfo(isKey: true)
  }
  
  func windowDidResignKey(_ notification: Notification) {
    windowData.windowKeyInfo = WindowData.WindowKeyInfo(isKey: false)
  }
  
  func windowDidResize(_ notification: Notification) {
    let videoRect = windowData.playerView.videoRect
    
    let pausedLocalizations = windowData.pausedLocalizations()
    DispatchQueue.main.async { [weak self] in
      guard let windowData = self?.windowData else { return }

      windowData.videoControl.play(rate: 0.0)
      windowData.playerView.clear()
      windowData.localizations.clearSelected()
      
      for localization in pausedLocalizations {
        localization.resize(for: videoRect)
        windowData.playerView.display(localization: localization)
      }

      windowData.sliderView.setupControlViewAnimation()

      /// Resize all localizations on background queue. Although paused localizations are resized again,
      /// preventing that would be more overhead than re-resizing.
      self?.queue.async {
        windowData.localizations.resize(for: videoRect)
      }
    }
  }
}
