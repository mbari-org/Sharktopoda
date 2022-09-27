//
//  VideoWindow.swift
//  Created for Sharktopoda on 9/26/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import AppKit
import SwiftUI

class VideoWindow: NSWindow {
  let videoView: VideoView
  
  init(for videoAsset: VideoAsset) {
    self.videoView = VideoView(videoAsset: videoAsset)
    
    super.init(
      contentRect: NSRect(x: 20, y: 20, width: 680, height: 600),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered,
      defer: false)
    self.center()
    self.isReleasedWhenClosed = false
    self.title = videoAsset.uuid
    self.makeKeyAndOrderFront(nil)

    self.contentView = NSHostingView(rootView: self.videoView)
    
    self.delegate = self
  }
}

extension VideoWindow: NSWindowDelegate {
  func windowWillClose(_ notification: Notification) {
    DispatchQueue.main.async {
      UDP.sharktopodaData.videoWindows.removeValue(forKey: self.videoView.videoAsset.uuid)
    }
  }
}
