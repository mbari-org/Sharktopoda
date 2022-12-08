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
    windowData.pause(true)
    
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
    }
    
    /// Resize all non-paused localizations on background queue. Paused localizations are resized on the main
    /// thread. If resized again here, the paused Location display is clunky.
    resizingTask?.cancel()
    resizingTask = Task(priority: .background) { [weak windowData] in
      guard let windowData = windowData else { return }

//      do {
//        try await Task.sleep(for: .milliseconds(333))
//      } catch {
//        // no-op.
//      }

      let pausedIds = pausedLocalizations.map(\.id)
      for (id, localization) in windowData.localizations.storage {
        if !pausedIds.contains(id) {
          localization.resize(for: videoRect)
        }
      }
    }
  }
}
