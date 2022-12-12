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

    playerDirection = windowData.playerDirection

    DispatchQueue.main.async { [weak self] in
      guard let windowData = self?.windowData else { return }

      if windowData.playerDirection != .paused {
        windowData.videoControl.play(rate: 0.0)
        windowData.playerView.clear()
        windowData.localizationData.clearSelected()
      } else {
        windowData.localizationData.clearSelected()
      }
      
      for localization in pausedLocalizations {
        localization.resize(for: videoRect)
      }

      windowData.sliderView.setupControlViewAnimation()

      // CxTBD This is a bit wonky. Investigate
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) { [weak self] in
        guard let self = self else { return }
        guard let playerDirection = self.playerDirection else { return }
        
        self.windowData.playerResume(playerDirection)
      }
    }
    
    /// Resize all non-paused localizations on background queue. Paused localizations are resized on the main
    /// thread. If resized again here, the paused Location display is clunky.
    resizingTask?.cancel()
    resizingTask = Task.detached(priority: .background) { [weak windowData] in
      guard let windowData = windowData else { return }

      do {
        try await Task.sleep(for: .milliseconds(333))
      } catch {
        // no-op
      }

      let pausedIds = pausedLocalizations.map(\.id)
      for (id, localization) in windowData.localizationData.storage {
        if !pausedIds.contains(id) {
          localization.resize(for: videoRect)
        }
      }
    }
  }
}
