//
//  VideoExtension.swift
//  Created for Sharktopoda on 9/26/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

extension VideoView {
  private func newWindow(with videoAsset: VideoAsset) -> NSWindow {
    let window = NSWindow(
      contentRect: NSRect(x: 20, y: 20, width: 680, height: 600),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered,
      defer: false)
    window.center()
    window.isReleasedWhenClosed = false
    window.title = videoAsset.uuid
    window.makeKeyAndOrderFront(nil)
    return window
  }
  
  func openInWindow() -> NSWindow {
    let window = self.newWindow(with: self.videoAsset)
    window.contentView = NSHostingView(rootView: self)
    return window
  }
}
