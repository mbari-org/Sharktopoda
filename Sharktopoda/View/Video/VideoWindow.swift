//
//  VideoWindow.swift
//  Created for Sharktopoda on 9/26/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import AppKit
import AVFoundation
import SwiftUI

class VideoWindow: NSWindow {
  struct KeyInfo {
    var keyTime: Date
    var isKey: Bool = false
    
    static func <(lhs: KeyInfo, rhs: KeyInfo) -> Bool {
      lhs.keyTime < rhs.keyTime
    }
  }

  var videoPlayerView = VideoPlayerView()
  
  var videoView: VideoView
  var keyInfo: KeyInfo
  
  var localizations = LocalizationSet()

  init(for videoAsset: VideoAsset) {
    keyInfo = KeyInfo(keyTime: Date())

    videoPlayerView.asset = videoAsset

    videoView = VideoView(videoAsset: videoAsset)
    
    let videoSize = videoView.videoSize()
    let windowSize = VideoWindow.scaleSize(size: videoSize)
    
    super.init(
      contentRect: NSMakeRect(0, 0, windowSize.width, windowSize.height),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered,
      defer: false)
    center()
    isReleasedWhenClosed = false
    title = videoAsset.id
    makeKeyAndOrderFront(nil)
    
//    contentView = NSHostingView(rootView: self.videoView)
    contentView = videoPlayerView
    
    delegate = self
  }
}

/// Convenience functions
extension VideoWindow {
  func canStep(_ steps: Int) -> Bool {
    videoView.canStep(steps)
  }
  
  func elapsedTimeMillis() -> Int {
    videoView.elapsedTimeMillis()
  }

  func frameGrab(at captureTime: Int, destination: String) async -> FrameGrabResult {
    await videoView.frameGrab(at: captureTime, destination: destination)
  }
  
  var id: String {
    videoView.videoAsset.id
  }
  
  func pause() {
    videoView.pause()
  }
  
  func play(rate: Float) {
    videoView.rate = rate
  }
  
  var rate: Float {
    videoView.rate
  }
  
  func seek(elapsed: Int) {
    videoView.seek(elapsed: elapsed)
  }
  
  func step(_ steps: Int) {
    videoView.step(steps)
  }
  
  var url: URL {
    videoView.videoAsset.url
  }
}

/// Localizations
extension VideoWindow {
  
  func addLocalizations(_ localizationsToAdd: [Localization]) -> [Bool] {
    let added = localizationsToAdd.map { localization in
      localizations.add(localization)
    }
    
    //
    //    for (index, localization) in localizationsToAdd.enumerated() {
    //      if added[index] {
    //        let layer = localizationLayer(localization, width: width, color: color)
    //        avPlayerLayer.addSublayer(layer)
    //      }
    //    }
    
    return added
  }
  
  func clearLocalizations() {
    localizations.clear()
  }
  
  func removeLocalizations(_ localizationIds: [String]) -> [Bool] {
    localizationIds.map { id in
      localizations.remove(id: id)
    }
  }

  func selectedLocalizations() -> [Localization] {
    localizations.allSelected()
  }

  func selectLocalizations(_ localizationIds: [String]) -> [Bool] {
    localizations.clearSelected()
    
    return localizationIds.map { id in
      localizations.select(id)
    }
  }
  
  func updateLocalizations(_ updatedLocalizations: [Localization]) -> [Bool] {
    updatedLocalizations.map { localization in
      localizations.update(localization)
    }
  }
}

/// Function overrides
extension VideoWindow {
  override func makeKeyAndOrderFront(_ sender: Any?) {
    super.makeKeyAndOrderFront(sender)
    self.keyInfo = KeyInfo(keyTime: Date(), isKey: true)
  }
}

/// Static functions
extension VideoWindow {
  static func <(lhs: VideoWindow, rhs: VideoWindow) -> Bool {
    lhs.keyInfo < rhs.keyInfo
  }
  
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
  
  static func open(path: String) -> Error? {
    open(id: path, url: URL(fileURLWithPath: path))
  }
  
  static func open(id: String, url: URL) -> Error? {
    if let videoWindow = UDP.sharktopodaData.videoWindows.values.first(where: { $0.url == url } ) {
      DispatchQueue.main.async {
        videoWindow.makeKeyAndOrderFront(nil)
      }
    } else {
      do {
        if !(try url.checkResourceIsReachable()) {
          return OpenVideoError.notReachable
        }
      } catch let error {
        return error
      }

      let videoAsset = VideoAsset(id: id, url: url)
      guard videoAsset.avAsset.isPlayable else {
        return OpenVideoError.notPlayable
      }
      DispatchQueue.main.async {
        let videoWindow = VideoWindow(for: videoAsset)
        videoWindow.makeKeyAndOrderFront(nil)
        UDP.sharktopodaData.videoWindows[id] = videoWindow
      }
    }
    return nil
  }
}

extension VideoWindow: NSWindowDelegate {
  func windowWillClose(_ notification: Notification) {
    DispatchQueue.main.async {
      UDP.sharktopodaData.videoWindows.removeValue(forKey: self.videoView.videoAsset.id)
    }
  }
  
  func windowDidBecomeKey(_ notification: Notification) {
    self.keyInfo = KeyInfo(keyTime: Date(), isKey: true)
  }
  
  func windowDidResignKey(_ notification: Notification) {
    self.keyInfo = KeyInfo(keyTime: self.keyInfo.keyTime, isKey: false)
  }
}

enum OpenVideoError: Error {
  case invalidUrl
  case notPlayable
  case notReachable
  case unknown(_ cause: String)
  
  var description: String {
    switch self {
      case .invalidUrl:
        return "Invalid URL"
        
      case .notPlayable:
        return "Resource not playable"
        
      case .notReachable:
        return "Video file not reachable"
        
      case .unknown(let cause):
        return cause
    }
  }
  
  var localizedDescription: String {
    self.description
  }
}
