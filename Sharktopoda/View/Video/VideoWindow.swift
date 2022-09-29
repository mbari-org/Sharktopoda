//
//  VideoWindow.swift
//  Created for Sharktopoda on 9/26/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import AppKit
import AVKit

class VideoWindow: NSWindow {
  let videoAsset: VideoAsset

  let videoPlayer: AVPlayer
  let videoPlayerView: AVPlayerView
  
  init(for videoAsset: VideoAsset) {
    self.videoAsset = videoAsset
    
    videoPlayer = AVPlayer(url: videoAsset.url)
    videoPlayerView = AVPlayerView()

    videoPlayerView.player = videoPlayer

    let videoSize = self.videoAsset.size() ?? NSMakeSize(600, 600)
    let windowSize = VideoWindow.scaleSize(size: videoSize)
    
    super.init(
      contentRect: NSMakeRect(0, 0, windowSize.width, windowSize.height),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered,
      defer: false)
    self.center()
    self.isReleasedWhenClosed = false
    self.title = videoAsset.uuid
    self.makeKeyAndOrderFront(nil)

    self.contentView = self.videoPlayerView
    
    self.delegate = self
  }
}

extension VideoWindow {
  static func scaleSize(size: NSSize) -> NSSize {
    let screenFrame = NSScreen.main!.frame
    let maxSize = NSMakeSize(0.9 * screenFrame.width, 0.9 * screenFrame.height)

    if size.width < maxSize.width && size.height < maxSize.height {
      return size
    }

    let widthScale: CGFloat = maxSize.width / size.width
    let heightScale: CGFloat = maxSize.height / size.height

    let scale = widthScale < heightScale ? widthScale : heightScale

    return NSMakeSize(size.width * scale, size.height * scale)
  }
}

extension VideoWindow: NSWindowDelegate {
  func windowWillClose(_ notification: Notification) {
    DispatchQueue.main.async {
      UDP.sharktopodaData.videoWindows.removeValue(forKey: self.videoAsset.uuid)
    }
  }
}
